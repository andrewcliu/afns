# Define a map for day names to weekday numbers
day_of_week_map = {
  "sunday" => 0,
  "monday" => 1,
  "tuesday" => 2,
  "wednesday" => 3,
  "thursday" => 4,
  "friday" => 5,
  "saturday" => 6
}

# Define date range for seeding
start_date = Date.today - 50 # 30 days ago
end_date = Date.today

puts "Seeding attendance data from #{start_date} to #{end_date}"

AfnsClassSchedule.all.each do |schedule|
  puts "Processing schedule #{schedule.id}"

  # Get the expected day of the week for this schedule
  schedule_day = day_of_week_map[schedule.day_of_week]

  # Loop through each date in the specified range
  (start_date..end_date).each do |date|
    # Check if the date's day of week matches the schedule's day
    next unless date.wday == schedule_day
    
    puts "Creating data for date: #{date}"

    # Check if there is already an attendance record with a non-zero count
    existing_attendance = schedule.afns_class_attendances.find_by(attendance_date: date)

    # Skip if there is a non-zero attendance count
    if existing_attendance && existing_attendance.attendance_count.to_i > 0
      puts "Skipping date #{date} for schedule #{schedule.id} (already has attendance)"
      next
    end

    # Otherwise, create a new attendance record with a random count
    attendance_count = rand(5..30) # Random count between 5 and 30

    begin
      schedule.afns_class_attendances.create!(
        attendance_date: date,
        attendance_count: attendance_count
      )
      puts "Created attendance for Schedule #{schedule.id} on #{date} with count #{attendance_count}"
    rescue => e
      puts "Error creating attendance for Schedule #{schedule.id} on #{date}: #{e.message}"
    end
  end
end

puts "Dummy attendance data generation complete."
