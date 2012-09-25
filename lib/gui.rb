#--
# jtorchat is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# jtorchat is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with jtorchat. If not, see <http://www.gnu.org/licenses/>.
#++

require 'gui/helpers'


class GUI
  import javax.swing.UIManager
  import javax.swing.JTabbedPane
  import javax.swing.ImageIcon
  import javax.swing.JLabel
  import javax.swing.JPanel
  import javax.swing.JFrame
  import javax.swing.JComponent
  import javax.swing.SwingUtilities
  import javax.swing.UIManager
  import java.awt.BorderLayout
  import java.awt.Dimension
  import java.awt.GridLayout
  import java.awt.event.KeyEvent
    import java.awt.BorderLayout
  import java.awt.Dimension
  
  import javax.swing.BorderFactory
  import javax.swing.JScrollPane
  import javax.swing.JList
  import javax.swing.GroupLayout
  import javax.swing.JButton
  import javax.swing.SwingConstants
  import java.awt.FlowLayout
  import javax.swing.BoxLayout
  import javax.swing.Box
  import javax.swing.JComboBox

  attr_reader :options, :profile

  def initialize (options = {})
    @options = options
    @profile = options[:config] ? Torchat.new(options[:config]) : Torchat.profile(options[:profile])
    
    UIManager.getInstalledLookAndFeels().each {|x|

      if(x.getName() == "Nimbus")
        puts "nimbus we have"
        UIManager.setLookAndFeel(x.getClassName());
        break
      end
    }
    
  end
  
  def start
    @thread = Thread.new {
      EM.run {
        @profile.start {|s|
        }
      }
    }
    
    
    
    
    # @frame = JFrame.new('jtorchat')
    # @frame.getContentPane().add(JLabel.new('this be jtorchat'))
    # @frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    # @frame.pack
    # @frame.set_visible(true);
    initUI()
    
  end
  
  def initUI
    

    @panel = JPanel.new
    @panel.setPreferredSize(Dimension.new(300,300))
    @panel.setLayout(GridLayout.new(1,1))

    
    tabbedpane = JTabbedPane.new
    
    basic = JPanel.new
    basic.setLayout(BoxLayout.new( basic, BoxLayout::Y_AXIS))
    bottom = JPanel.new
    bottom.setLayout(BoxLayout.new(bottom, BoxLayout::X_AXIS))
    bottom.setAlignmentX(0.5)
    user_list = JList.new(["culetto","marcio","pieno"].to_java)

    user_list.add_list_selection_listener do |e|
      
      sender = e.source
      if not e.getValueIsAdjusting
        flag = true;
        0.upto(tabbedpane.getTabCount()-1) do |x|
          
          if(tabbedpane.getTitleAt(x) == sender.getSelectedValue)
            tabbedpane.setSelectedIndex(x)
            flag = false;
            break;
          end
        end
        if flag 
          tabbedpane.addTab(sender.getSelectedValue,create_new_tab(sender.getSelectedValue))
          tabbedpane.setSelectedIndex(tabbedpane.getTabCount()-1)
        end
      end
    end
    pane = JScrollPane.new
    pane.getViewport.add(user_list)
    pane.setPreferredSize(Dimension.new(200, 250))
    basic.add(pane)
    status = JComboBox.new(["Available","Busy","Offline"].to_java)
    torc =   ImageComboBox.new
   # @user_list.setCellRenderer(torc)
    status.setRenderer(torc)
    bottom.add(status)
    basic.add(bottom)

    

    tabbedpane.addTab("user list",nil,basic,"yoyo")

    tabbedpane.setTabLayoutPolicy(JTabbedPane::SCROLL_TAB_LAYOUT)
    @panel.add(tabbedpane)

    @frame = JFrame.new("tor")
    @frame.add(@panel)
    @frame.pack

    @frame.setPreferredSize(Dimension.new(300, 300))
    @frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    @frame.setLocationRelativeTo(nil)
    @frame.setVisible(true)

  end
  
  def stop
    profile.stop
    
    EM.stop_event_loop
    
    @thread.join
  end


  def create_new_tab(val)

    ntab = JPanel.new
    ntab.add(JLabel.new(val))
    return ntab
  end


  class ImageComboBox < javax.swing.JLabel
  include javax.swing.ListCellRenderer
    import javax.swing.ImageIcon
    import java.net.URL
    def initialize
      super()
          self.setOpaque(true)

    end
    
    def getListCellRendererComponent(list,value,index,isSelected,cellHasFocus)
      setText(value)
     
        case value.downcase
        when "available"
          
          setIcon(ImageIcon.new(File.dirname(__FILE__)+"/../data/icons/user-online.png"))
        when "busy"
          setIcon(ImageIcon.new(File.dirname(__FILE__)+"/../data/icons/user-busy.png"))
        when "offline"
          setIcon(ImageIcon.new(File.dirname(__FILE__)+"/../data/icons/user-offline.png"))
        else
        end

      self
    end
  end

end
