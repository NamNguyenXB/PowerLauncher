using System.Windows.Controls;

namespace PowerLauncher.View
{
    public partial class Config : UserControl
    {
        public Config(string setupContent)
        {
            InitializeComponent();
            SetupTextBox.Text = setupContent;
        }
    }
}
