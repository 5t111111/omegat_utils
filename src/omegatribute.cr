require "./omegatribute/*"
require "colorize"
require "crypto/md5"

module Omegatribute

  def self.compare_files(file_a, file_b)
    file_a_md5 = Crypto::MD5.hex_digest(File.read(file_a))
    file_b_md5 = Crypto::MD5.hex_digest(File.read(file_b))
    file_a_md5 == file_b_md5
  end

  def self.copy_to_omegat_source_directory(src_dir, dst_dir)
    Dir.glob(src_dir + "/*") do |f|
      if File.directory?(f)
        self.copy_to_omegat_source_directory(f, File.join(dst_dir, File.basename(f)))
      end
      next unless File.extname(f) == ".md"
      dst_file = File.join(dst_dir, File.basename(f))

      if File.exists?(dst_file)
        next if compare_files(f, dst_file)
      else
        puts "NEW:  #{dst_file}".colorize(:yellow)
      end
      puts "FROM: #{f}".colorize(:cyan)
      puts "TO:   #{dst_file}".colorize(:magenta)
      Dir.mkdir_p(File.dirname(dst_file))
      File.write(dst_file, File.read(f))
    end
  end


  def self.copy_back_md_to_repo(src_dir, dst_dir)
    Dir.glob(src_dir + "/*") do |f|
      if File.directory?(f)
        self.copy_back_md_to_repo(f, File.join(dst_dir, File.basename(f)))
      end
      next unless File.extname(f) == ".md"
      dst_file = File.join(dst_dir, File.basename(f))
      puts "FROM: #{f}".colorize(:cyan)
      puts "TO:   #{dst_file}".colorize(:magenta)
      File.write(dst_file, File.read(f))
    end
  end
end
