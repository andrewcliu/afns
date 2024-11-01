# app/services/google_wallet_service.rb
require 'rest-client'
require 'json'
require 'jwt'
require 'openssl'
require 'securerandom'

class GoogleWalletService
  GOOGLE_WALLET_SCOPE = 'https://www.googleapis.com/auth/wallet_object.issuer'.freeze
  GOOGLE_WALLET_API_BASE = 'https://walletobjects.googleapis.com/walletobjects/v1'.freeze

  def initialize(member, initialize_wallet = true)
    @member = member
    @key_file_path = ENV.fetch('GOOGLE_APPLICATION_CREDENTIALS', Rails.root.join('config/google_api.json'))

    setup_credentials if initialize_wallet
  end
  def setup_credentials
    file = File.read(@key_file_path)
    key_data = JSON.parse(file)
    @client_email = Rails.application.credentials[:google_wallet_email]
    @private_key = OpenSSL::PKey::RSA.new(key_data['private_key'])
  end

  def create_class(issuer_id, class_suffix)
    resource_id = "#{issuer_id}.#{class_suffix}"
    url = "#{GOOGLE_WALLET_API_BASE}/genericClass/#{resource_id}"

    begin
      response = RestClient.get(url, { Authorization: "Bearer #{auth_token}" })
      puts "Class #{resource_id} already exists!"
      return JSON.parse(response.body)
    rescue RestClient::NotFound
    end

    new_class = {
      id: resource_id,
      issuerName: 'Your Issuer Name',
      reviewStatus: 'UNDER_REVIEW'
    }

    response = RestClient.post("#{GOOGLE_WALLET_API_BASE}/genericClass",
                               new_class.to_json,
                               { Authorization: "Bearer #{auth_token}", content_type: :json })
    JSON.parse(response.body)
  end

  def create_object(issuer_id, class_suffix, object_suffix)
    resource_id = "#{issuer_id}.#{object_suffix}"
    url = "#{GOOGLE_WALLET_API_BASE}/genericObject/#{resource_id}"

    begin
      response = RestClient.get(url, { Authorization: "Bearer #{auth_token}" })
      puts "Object #{resource_id} already exists!"
      return JSON.parse(response.body)
    rescue RestClient::NotFound
    end

    new_object = {
      id: resource_id,
      classId: "#{issuer_id}.#{class_suffix}",
      state: @member.is_active,
      cardTitle:{
        defaultValue: {
          language: 'en-US',
          value: 'Alameda Fitness & Spa Member'
        }
      },
      subheader:{
        defaultValue:{
          language: 'en-US',
          value: 'Member'
        }
      },
      header:{
        defaultValue: {
          language: 'en-US',
          value: @member.name
        }
      },
      heroImage:{
        sourceUri:{
          uri: "https://alamedafns.com/wp-content/uploads/2022/04/LOGO-ASF-01-800x223.png"
        }
      },
      hexBackgroundColor:'#EEE',
      barcode: { type: 'CODE_128', value: @member.membership_number },
      textModulesData: [
        { 
          header: 'Member Information', 
          body: "Name: #{@member.name}\nEmail: #{@member.email}\nStatus: #{@member.is_active ? 'Active' : 'Inactive'}",
          id: 'MEMBER_INFO'
        },
        {
          header: 'About Your Membership',
          body: "Enjoy exclusive access to all facilities and classes. Visit alamedafns.com for updates and events.",
          id: 'ABOUT_MEMBERSHIP'
        }
      ]
    }

    response = RestClient.post("#{GOOGLE_WALLET_API_BASE}/genericObject",
                               new_object.to_json,
                               { Authorization: "Bearer #{auth_token}", content_type: :json })
    JSON.parse(response.body)
  end

  def create_jwt_new_objects(issuer_id, class_suffix, object_suffix)
    payload = {
      iss: @client_email,
      aud: 'google',
      origins: ['localhost'],
      typ: 'savetowallet',
      payload: {
        genericClasses: [{
          id: "#{issuer_id}.#{class_suffix}"
        }],
        genericObjects: [{
          id: "#{issuer_id}.#{object_suffix}",
          classId: "#{issuer_id}.#{class_suffix}",
          state: 'ACTIVE',
          cardTitle:{
            defaultValue: {
              language: 'en-US',
              value: 'Alameda Fitness & Spa'
            }
          },
          subheader:{
            defaultValue:{
              language: 'en-US',
              value: "Member since #{@member.date_join.strftime('%m/%d/%Y')}"
            }
          },
          header:{
            defaultValue: {
              language: 'en-US',
              value: @member.name
            }
          },
          barcode: { type: 'CODE_128', value: @member.membership_number },
          hexBackgroundColor:'#EEE',
          heroImage:{
            sourceUri:{
              uri: "https://alamedafns.com/wp-content/uploads/2022/04/LOGO-ASF-01-800x223.png"
            }
          },
          textModulesData: [
            { 
              header: 'Member Information', 
              body: "Name: #{@member.name}\nEmail: #{@member.email}\nStatus: #{@member.is_active ? 'Active' : 'Inactive'}",
              id: 'MEMBER_INFO'
            },
            {
              header: 'About Your Membership',
              body: "Enjoy exclusive access to all facilities and classes. Visit alamedafns.com for updates and events.",
              id: 'ABOUT_MEMBERSHIP'
            }
          ]
        }]
      }
    }

    token = JWT.encode(payload, @private_key, 'RS256')
    "https://pay.google.com/gp/v/save/#{token}"
  end

  private

  def auth_token
    payload = {
      iss: @client_email,
      scope: GOOGLE_WALLET_SCOPE,
      typ: "savetowallet",
      aud: 'https://oauth2.googleapis.com/token',
      exp: Time.now.to_i + 3600,
      iat: Time.now.to_i
    }

    assertion = JWT.encode(payload, @private_key, 'RS256')
    response = RestClient.post('https://oauth2.googleapis.com/token', {
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: assertion
    })
    JSON.parse(response.body)['access_token']
  end
end
