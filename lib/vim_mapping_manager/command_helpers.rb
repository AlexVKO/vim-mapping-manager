module CommandHelpers
  def current_file_path
    "<C-R>=expand('%')<CR>"
  end

  def move_cursor(count, unit, direction)
    cmd = ''

    count.times do
      if unit === :chars
        cmd << '<Left>'
      end
    end

    cmd
  end
end

