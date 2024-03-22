require_relative 'csvFileReader'

class Student < Csv_File_Reader
end

s = Student.new
p s.methods
s.student_id = 10
s.student_name = "Amit"
s.teacher_name = "Shilesh"
s.subject = "Physics"
s1 =  Student.find_by("student_id", 3)
s2 =  Student.find_by("teacher_name", "surya")
s3 =  Student.find_by("teacher_name", "")
s3 =  Student.find_by("subject", "science")
p s1
p s2
p s3
puts s1.student_name # this should print kiran 
puts s1.teacher_name # this should print manoj