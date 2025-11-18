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

        Task.Run(async () =>
        {
            while (_server.IsListening)
            {
                HttpListenerContext? ctx = null;
                try
                {
                    ctx = await _server.GetContextAsync();
                    Console.WriteLine("Request received");
                    
                    var data = await CaptureMainWindowAsPngAsync();
                    Console.WriteLine($"Encoded {data.Length} bytes");
                    
                    ctx.Response.ContentType = "image/png";
                    ctx.Response.ContentLength64 = data.Length;
                    ctx.Response.StatusCode = 200;
                    
                    await ctx.Response.OutputStream.WriteAsync(data, 0, data.Length);
                    ctx.Response.Close();
                    Console.WriteLine("Response sent");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"VibeServer error: {ex}");
                    if (ctx != null)
                    {
                        try
                        {
                            ctx.Response.StatusCode = 500;
                            ctx.Response.Close();
                        }
                        catch { }
                    }
                }
            }
        });
    }

    public static void Shutdown()
    {
        _server?.Stop();
        _server?.Close();
    }

    private static async Task<byte[]> CaptureMainWindowAsPngAsync()
    {
        var tcs = new TaskCompletionSource<byte[]>();

        _ = Application.Current.Dispatcher.BeginInvoke(() =>
        {
            try
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
                    
                    // Encode to PNG on the UI thread
                    using var ms = new MemoryStream();
                    var encoder = new PngBitmapEncoder();
                    encoder.Frames.Add(BitmapFrame.Create(renderBitmap));
                    encoder.Save(ms);
                    
                    tcs.SetResult(ms.ToArray());
                }
                else
                {
                    // Return a minimal 1x1 PNG
                    var bmp = BitmapSource.Create(1, 1, 96, 96, PixelFormats.Pbgra32, null, new byte[4], 4);
                    using var ms = new MemoryStream();
                    var encoder = new PngBitmapEncoder();
                    encoder.Frames.Add(BitmapFrame.Create(bmp));
                    encoder.Save(ms);
                    tcs.SetResult(ms.ToArray());
                }
            }
            catch (Exception ex)
            {
                tcs.SetException(ex);
            }
        });

        return await tcs.Task;
    }
}
