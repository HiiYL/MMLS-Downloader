require 'mechanize'
require "highline/import"
agent = Mechanize.new
agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
page = agent.get("https://mmls.mmu.edu.my")
form = page.form

student_id = ask "Input Student ID: "
mmls_password = ask("Input MMLS password (Input will be hidden): ") { |q| q.echo = false }

form.stud_id = student_id# INPUT YOUR STUDENT ID
form.stud_pswrd = mmls_password# INPUT YOUR MMLS PASSWORD
page = agent.submit(form)
if page.parser.xpath('//*[@id="alert"]').empty?
  agent.pluggable_parser.default = Mechanize::Download
  subject_links = page.links_with(:text => /[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9] . [A-Z][A-Z][A-Z]/)
  subject_links.each do |link|
    page = agent.get(link.uri)
    print "\n Current Subject: "  + link.text
    page.forms_with(:action => 'https://mmls.mmu.edu.my/form-download-content').each do |dl_form|
      directory = link.text + "/"
      file_name = dl_form.file_name
      print "\n Downloading " + file_name
      if Dir[directory + file_name].empty?
        agent.submit(dl_form).save(directory + file_name)
        print "\n File saved as " + directory + file_name
      else
        print "\n Duplicate file found in destination, skipping ..."
      end
    end
  end
else
  print "Student ID or password is invalid... Exiting\n"
end