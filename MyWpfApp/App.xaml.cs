using System.Runtime.InteropServices;
using System.Windows;

namespace MyWpfApp;

/// <summary>
/// Interaction logic for App.xaml
/// </summary>
public partial class App : Application
{
    [DllImport("kernel32.dll")]
    static extern bool AttachConsole(int dwProcessId);
    const int ATTACH_PARENT_PROCESS = -1;

    public App()
    {
#if DEBUG
        AttachConsole(ATTACH_PARENT_PROCESS);
        Console.WriteLine("Debug console attached.");

        VibeExtensions.VibeServer.Initialize();
#endif
    }
}

