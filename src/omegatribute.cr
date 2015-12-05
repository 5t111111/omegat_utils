require "./omegatribute/*"
require "option_parser"

# crystal build src/omegatribute.cr && ./omegatribute -s ~/Dropbox/Documents/Translations/OmegaT\ Projects/crystal-jp-gh-pages-omegat/target/crystal-jp-gh-pages -d ~/Dropbox/Documents/Translations/Repositories/crystal-jp-gh-pages

module Omegatribute

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

src_dir = ""
dst_dir = ""

OptionParser.parse! do |parser|
  parser.banner = "Usage: xxxx [arguments]"
  parser.on("-s SRC", "--src=SRC", "Specifies the source directory that contains translated markdown files (in general it should be a directory in OmegaT's target directory)") { |src| src_dir = src }
  parser.on("-d DST", "--dst=DST", "Specifies the destination directory in a git repository (in general it should be a directory corresponding to the source sirectory)") { |dst| dst_dir = dst }
  parser.on("-h", "--help", "Show this help") { puts parser }
end

if src_dir == ""
  puts "Error: Source directory is not specified"
  exit 1
end

if dst_dir == ""
  puts "Error: Destination directory is not specified"
  exit 1
end

unless File.directory?(src_dir)
  puts "Error: #{src_dir} is not a directory."
  exit 1
end

unless File.directory?(dst_dir)
  puts "Error: #{dst_dir} is not a directory."
  exit 1
end

Omegatribute.copy_back_md_to_repo(src_dir, dst_dir)
