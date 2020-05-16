require 'neovim'
require_relative '../../lib/vim_mapping_manager.rb'

Neovim.plugin do |plug|
  # Define an autocmd for the BufEnter event on Ruby files.
  plug.autocmd(:BufWritePost, pattern: "*managed_mappings.rb") do |nvim|
    VimMappingManager.save
    nvim.command("echom 'Mappings updated ~/.config/nvim/managed_mappings.rb'")
  end

  plug.command(:EditMappings) do |nvim|
    VimMappingManager.reset!
    nvim.command('tabnew ~/.config/nvim/managed_mappings.rb')

    example = <<-EXAMPLE
      # Example
      #
      # You can map single maps like this one, for the normal mode
      # normal('<leader>e', 'gg=G<C-O>', desc: 'indent current file')

      # But also more compex ones, like mappings with prefixes
      # prefix(',', name: 'Files', desc: 'Mappings related to file manipulation') do
      #   normal('du', ":saveas \#{current_file_path}", desc: "Duplicate current file")
      #   normal('ct', ':checktime',                   desc: 'Reload the file')
      #   normal('de', ':!rm %',                       desc: 'Delete current file')
      # end
    EXAMPLE

    if nvim.current.buffer.lines.to_a.count <= 1
      nvim.current.buffer.lines = example.gsub(/^ */, '').lines.map(&:chomp)
    end
  end
end
