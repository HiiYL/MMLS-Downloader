require 'mechanize'
require "highline/import"
require 'daybreak'
require 'colorize'


class MMLS

  def initialize
    ObjectSpace.define_finalizer(self, self.class.method(:finalize))  # Works in both 1.9.3 and 1.8
    #ObjectSpace.define_finalizer(self, FINALIZER)                    # Works in both
    #ObjectSpace.define_finalizer(self, method(:finalize))            # Works in 1.9.3
  end
  def self.set_path(path)
    @db = Daybreak::DB.new "mmls.db"
    case path.downcase
      when "icloud"
        path = "/Users/"+ ENV['USER'] +"/Library/Mobile\ Documents/com~apple~CloudDocs"
      when "documents"
        path = "/Users/" + ENV['USER'] + "/Documents"
      when "downloads"
        path = "/Users/" + ENV['USER'] + "/Downloads"
    end
    @db.set! 'save_path', path
    puts "Downloads will now save in : " + @db['save_path']
    @db.close
  end

  def self.finalize(object_id)
    p "finalizing %d" % object_id
    @db.close
  end
  def finalize(object_id)
    @db.close
    p "finalizing %d" % object_id
  end
  def self.update()
    @db = Daybreak::DB.new "mmls.db"
    agent = Mechanize.new
    agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    page = agent.get("https://mmls.mmu.edu.my")
    form = page.form
    print "               #######################################\n"
    print "               |         MMLS      DOWNLOADER        |\n"
    print "               |               BY                    |\n"
    print "               |           HII YONG LIAN             |\n"
    print "               #######################################\n"
    if @db.keys.include? 'mmls_password'
      print "            ----------    Loaded MMLS Password --------  "
      form.stud_id = @db['student_id']# INPUT YOUR STUDENT ID
      form.stud_pswrd = @db['mmls_password']# INPUT YOUR MMLS PASSWORD
      page = agent.submit(form)
    else
      loop do
        student_id = ask "Input Student ID: "
        mmls_password = ask("Input MMLS password (Input will be hidden): ") { |q| q.echo = false }

        form.stud_id = student_id# INPUT YOUR STUDENT ID
        form.stud_pswrd = mmls_password# INPUT YOUR MMLS PASSWORD
        page = agent.submit(form)
        if page.parser.xpath('//*[@id="alert"]').empty?
          @db.set! 'student_id', student_id
          @db.set! 'mmls_password', mmls_password
          set_path
          break
        end
        retry_reply = ask("Student ID or password is invalid... Would you like to retry? (Y/N)")
        loop do
          if(retry_reply == 'Y' or retry_reply == 'y')
            break
          elsif(retry_reply == 'N' or retry_reply == 'n')
            @db.close
            exit
          else
            retry_reply = ask("Unrecognized input... Would you like to retry? (Yy/Nn)")
          end
        end
      end
    end
    @db.close
    agent.pluggable_parser.default = Mechanize::Download
    agent.agent.http.retry_change_requests = true
    puts
    puts "Saving in directory: " + @db['save_path']
    subject_links = page.links_with(:text => /[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9] . [A-Z][A-Z][A-Z]/)
    subject_links.each do |link|
      page = agent.get(link.uri)
      puts "\n Current Subject: "  + link.text
      page.forms_with(:action => 'https://mmls.mmu.edu.my/form-download-content').each do |dl_form|
        directory = link.text.split(" (").first + "/"
        full_directory = @db['save_path'] + "/" + link.text.split(" (").first + "/"
        file_name = dl_form.file_name
        if Dir[full_directory + file_name].empty?
          agent.submit(dl_form).save(full_directory + file_name)
          puts "create ".green  + directory + file_name
        # else
        #   puts "identical ".blue + file_name
        end
      end
    end
  end
end