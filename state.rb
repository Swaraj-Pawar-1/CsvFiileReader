require_relative 'csvFileReader'

class State < Csv_File_Reader
end
# class Student < CSVFileReader
# end
st = State.new
st.name = "Bihar"
st.capital = "Patna"
st.population = "22Crore"

p st

st1 = State.find_by("name", "Karnataka")
puts st1.capital # this should print Bangalore
puts st1.population # this should print 6 crore

