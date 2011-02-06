class AddCmd
  def initialize(text, first)
    @first, @text = first, text
  end

  def exec(str)
    str.insert(@first, @text)
  end
end


class RemoveCmd
  def initialize(first, last)
    @first, @last = first, last
  end

  def exec(str)
    str.slice!(@first...@last)
  end
end


module TextEditor
  class Document
    
    def initialize
      @commands = []
      @reverted = []
    end
    
    def contents()
      @commands.inject("") { |str, cmd| cmd.exec(str) && str }
    end

    def add_text(text, position=-1)
      @commands << AddCmd.new(text, position)
      @reverted.clear()      
    end

    def remove_text(first=0, last=contents.length)
      @commands << RemoveCmd.new(first, last)
      @reverted.clear()      
    end
  
    def undo
      return if @commands.empty?
      @reverted << @commands.pop()
    end

    def redo
      return if @reverted.empty?
      @commands << @reverted.pop
    end
  end
end
