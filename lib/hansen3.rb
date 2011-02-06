class AddCmd
  def initialize(text, first, contents)
    @text, @first, @contents = text, first, contents
  end

  def exec()
    @contents.insert(@first, @text)
  end
end


class RemoveCmd
  def initialize(first, last, contents)
    @first, @last, @contents = first, last, contents
  end

  def exec()
    @contents.slice!(@first...@last)
  end
end


module TextEditor
  class Document
    
    def initialize
      @contents = ""
      @commands = []
      @reverted = []
    end
    
    def contents()
      @contents.slice!(0..-1)
      @commands.each { |cmd| cmd.exec() }
      @contents
    end

    def add_text(text, position=-1)
      @commands << AddCmd.new(text, position, @contents)
      @reverted.clear()      
    end

    def remove_text(first=0, last=contents.length)
      @commands << RemoveCmd.new(first, last, @contents)
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
