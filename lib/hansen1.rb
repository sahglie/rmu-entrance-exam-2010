module TextEditor
  class Document
    
    def initialize
      @contents = ""
      @commands = []
      @command_history = []
      @reverted = []
    end
    
    def contents()
      while !@commands.empty?
        @command_history << @commands.shift.call()
      end
      @contents
    end

    def add_text(text, start_pos=-1)
      cmd = lambda do
        @contents.insert(start_pos, text)
        lambda do
          start_pos = @contents.length - text.length
          end_pos = start_pos + text.length
          @contents.slice!(start_pos...end_pos)
          cmd
        end
      end
      add_cmd(cmd)
    end

    def remove_text(start_pos=0, end_pos=contents.length)
      cmd = lambda do
        text = @contents.slice!(start_pos...end_pos)
        lambda do
          @contents.insert(start_pos, text)
          cmd
        end
      end
      add_cmd(cmd)
    end

    def undo
      return if @commands.empty? && @command_history.empty?
      unless @commands.empty?
        @reverted << @commands.pop()
      else
        @reverted << @command_history.pop.call()
      end
    end

    def redo
      return if @reverted.empty?
      @commands << @reverted.pop()
    end


    private
    
    def add_cmd(cmd)
      @commands << cmd
      @reverted.clear()      
    end
  end
end
