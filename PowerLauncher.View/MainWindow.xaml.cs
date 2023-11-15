using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;

namespace PowerLauncher.View
{
    public partial class MainWindow : Window
    {
        private string ModulesPath;
        private string InstallPath;
        private string LauncherPath;

        public MainWindow()
        {
            InitializeComponent();
            LoadLaunchers();
        }

        private void LoadLaunchers()
        {
            ModulesPath = Environment.GetEnvironmentVariable("PowerLauncher_ModulesDir");
            InstallPath = Environment.GetEnvironmentVariable("PowerLauncher_InstallDir");

            if (!string.IsNullOrEmpty(ModulesPath) && !string.IsNullOrEmpty(InstallPath))
            {
                string launchersFolderPath = Path.Combine(InstallPath, "Launchers");

                if (Directory.Exists(launchersFolderPath))
                {
                    string[] folderNames = Directory.GetDirectories(launchersFolderPath);
                    ListBox listBox = new ListBox();

                    foreach (string folder in folderNames)
                    {
                        var item = new ListBoxItem { Content = Path.GetFileName(folder) };
                        item.PreviewMouseLeftButtonUp += LauncherItemClicked;
                        listBox.Items.Add(item);
                    }

                    Launchers.Content = listBox;
                }
                else
                {
                    MessageBox.Show("Launchers folder not found.");
                }
            }
            else
            {
                MessageBox.Show("Environment variables not set.");
            }
        }

        private void LauncherItemClicked(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            string selectedFolder = ((ListBoxItem)sender).Content.ToString();
            LauncherPath = Path.Combine(InstallPath, "Launchers", selectedFolder);

            string modulesJsonPath = Path.Combine(LauncherPath, "modules.json");
            string setupJsonPath = Path.Combine(LauncherPath, "setup.json");

            if (File.Exists(modulesJsonPath) && File.Exists(setupJsonPath))
            {
                string modulesContent = File.ReadAllText(modulesJsonPath);
                ModuleList moduleList = new ModuleList(modulesContent);

                string setupContent = File.ReadAllText(setupJsonPath);
                Config config = new Config(setupContent);

                Grid grid = new Grid();
                grid.RowDefinitions.Add(new RowDefinition() { Height = GridLength.Auto });
                grid.RowDefinitions.Add(new RowDefinition() { Height = new GridLength(1, GridUnitType.Star) });

                grid.Children.Add(moduleList);
                grid.Children.Add(config);

                Grid.SetRow(config, 1);

                LauncherDetail.Content = grid;
            }
            else
            {
                MessageBox.Show("One or both JSON files not found in the selected launcher.");
            }
        }
    }
}
