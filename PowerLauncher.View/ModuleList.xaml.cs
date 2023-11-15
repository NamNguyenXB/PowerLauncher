using System.Windows.Controls;

namespace PowerLauncher.View
{
    public partial class ModuleList : UserControl
    {
        public ModuleList(string modulesContent)
        {
            InitializeComponent();
            ModulesTextBox.Text = modulesContent;
        }
    }
}
