require "./omegatribute/*"

module Omegatribute

  def self.copy_to_omegat_source_directory(src_dir, dst_dir)
    Dir.glob(src_dir + "/*") do |f|
      if File.directory?(f)
        self.copy_to_omegat_source_directory(f, File.join(dst_dir, File.basename(f)))
      end
      next unless File.extname(f) == ".md"
      dst_file = File.join(dst_dir, File.basename(f))
      puts "FROM: #{f}"
      puts "TO: #{dst_file}"
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
      puts "FROM: #{f}"
      puts "TO: #{dst_file}"
      File.write(dst_file, File.read(f))
    end
  end
end
