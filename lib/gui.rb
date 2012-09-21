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
  import java.awt.BorderLayout
  import java.awt.Dimension
  
  import javax.swing.JFrame
  import javax.swing.BorderFactory
  import javax.swing.JScrollPane
  import javax.swing.JPanel
  import javax.swing.JLabel
  import javax.swing.JList
  import javax.swing.GroupLayout
  import javax.swing.JButton
  import javax.swing.SwingConstants
  import java.awt.FlowLayout
  import javax.swing.BoxLayout
  import javax.swing.Box
  import javax.swing.JComboBox
  import java.awt.Dimension
  attr_reader :options, :profile

  def initialize (options = {})
    @options = options
    @profile = options[:config] ? Torchat.new(options[:config]) : Torchat.profile(options[:profile])
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
    @frame = JFrame.new("tor")
   
    @frame.setPreferredSize(Dimension.new(200, 300))

    basic = JPanel.new
    basic.setLayout(BoxLayout.new( basic, BoxLayout::Y_AXIS))
    bottom = JPanel.new
    bottom.setLayout(BoxLayout.new(bottom, BoxLayout::X_AXIS))
    bottom.setAlignmentX(0.5)
    list = JList.new(["culetto","marcio","pieno"].to_java)
    pane = JScrollPane.new
    pane.getViewport.add(list)
    pane.setPreferredSize(Dimension.new(200, 250))
    basic.add(pane)
    status = JComboBox.new(["Available","Away","Offline"].to_java)

    bottom.add(status)
    basic.add(bottom)

    @frame.add(basic)
    @frame.pack
    
    @frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    @frame.setLocationRelativeTo(nil)
    @frame.setVisible(true)
  end
  
  def stop
    profile.stop
    
    EM.stop_event_loop
    
    @thread.join
  end
end
