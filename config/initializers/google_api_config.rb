require 'base64'

# Example: Decode and write Base64-encoded JSON content to persistent storage
json_content = Base64.decode64(ENV['GOOGLE_API_KEY_BASE64'])

# Write the JSON content to Render's persistent disk
File.write("/var/data/google_api.json", json_content, perm: 0600)

