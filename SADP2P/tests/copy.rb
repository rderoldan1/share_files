require "open-uri"

file = "test.txt"
url  = "http://localhost/test.txt"

file = open(file,"wb")
file.write(open(url).read)
file.close
  
