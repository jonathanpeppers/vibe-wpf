using System.IO;
using System.Net;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace VibeExtensions;

public static class VibeServer
{
    private static HttpListener? _server;

    public static void Initialize()
    {
        _server = new HttpListener();
        _server.Prefixes.Add("http://localhost:5010/ui/");
        _server.Start();

        Task.Run(() =>
        {
            while (_server.IsListening)
            {
                try
                {
                    var ctx = _server.GetContext();
                    var bmp = CaptureMainWindowAsBitmap();
                    using var ms = new MemoryStream();
                    var encoder = new PngBitmapEncoder();
                    encoder.Frames.Add(BitmapFrame.Create(bmp));
                    encoder.Save(ms);

                    ctx.Response.ContentType = "image/png";
                    ctx.Response.OutputStream.Write(ms.ToArray());
                    ctx.Response.OutputStream.Close();
                }
                catch
                {
                    // Handle errors gracefully
                }
            }
        });
    }

    public static void Shutdown()
    {
        _server?.Stop();
        _server?.Close();
    }

    private static BitmapSource CaptureMainWindowAsBitmap()
    {
        BitmapSource? bitmap = null;

        Application.Current.Dispatcher.Invoke(() =>
        {
            var mainWindow = Application.Current.MainWindow;
            if (mainWindow != null)
            {
                var width = (int)mainWindow.ActualWidth;
                var height = (int)mainWindow.ActualHeight;

                var renderBitmap = new RenderTargetBitmap(
                    width,
                    height,
                    96,
                    96,
                    PixelFormats.Pbgra32);

                renderBitmap.Render(mainWindow);
                bitmap = renderBitmap;
            }
        });

        return bitmap ?? BitmapSource.Create(1, 1, 96, 96, PixelFormats.Pbgra32, null, new byte[4], 4);
    }
}
