module Snapshot
  module Storage
    class File 
      attr_reader :root
      def initialize(root_path)
        @root = root_path
      end

      def store(file)
        FileUtils.mkdir_p root  unless ::File.exist?(root)
        FileUtils.move(file,root) 
      end

      def retrieve(file_name)
        ::File.expand_path(file_name,root)
      end

      def remove(file_name)
        FileUtils.remove(retrieve(file_name)) 
      end

      def clear
        #FileUtils.remove_dir(root)
      end
    end
  end
end
