using System.IO;
using System.Net;
using System.Text;
using System.Text.Json;
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
        _server.Prefixes.Add("http://localhost:5010/tree/");
        _server.Start();

        Task.Run(async () =>
        {
            while (_server.IsListening)
            {
                HttpListenerContext? ctx = null;
                try
                {
                    ctx = await _server.GetContextAsync();
                    var path = ctx.Request.Url?.AbsolutePath ?? "";
                    Console.WriteLine($"Request received: {path}");
                    
                    if (path.StartsWith("/tree"))
                    {
                        var json = await GetVisualTreeAsJsonAsync();
                        var data = Encoding.UTF8.GetBytes(json);
                        Console.WriteLine($"Sending tree JSON: {data.Length} bytes");
                        
                        ctx.Response.ContentType = "application/json";
                        ctx.Response.ContentLength64 = data.Length;
                        ctx.Response.StatusCode = 200;
                        
                        await ctx.Response.OutputStream.WriteAsync(data, 0, data.Length);
                        ctx.Response.Close();
                    }
                    else // /ui endpoint
                    {
                        var data = await CaptureMainWindowAsPngAsync();
                        Console.WriteLine($"Encoded {data.Length} bytes");
                        
                        ctx.Response.ContentType = "image/png";
                        ctx.Response.ContentLength64 = data.Length;
                        ctx.Response.StatusCode = 200;
                        
                        await ctx.Response.OutputStream.WriteAsync(data, 0, data.Length);
                        ctx.Response.Close();
                    }
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

    public record Node(string Type, string? Name, List<Node> Children);

    private static async Task<string> GetVisualTreeAsJsonAsync()
    {
        var tcs = new TaskCompletionSource<string>();

        _ = Application.Current.Dispatcher.BeginInvoke(() =>
        {
            try
            {
                var mainWindow = Application.Current.MainWindow;
                if (mainWindow != null)
                {
                    var tree = BuildTree(mainWindow);
                    var json = JsonSerializer.Serialize(tree, new JsonSerializerOptions { WriteIndented = true });
                    tcs.SetResult(json);
                }
                else
                {
                    tcs.SetResult("{}");
                }
            }
            catch (Exception ex)
            {
                tcs.SetException(ex);
            }
        });

        return await tcs.Task;
    }

    private static Node BuildTree(DependencyObject root)
    {
        var n = new Node(root.GetType().Name,
                         (root as FrameworkElement)?.Name,
                         new List<Node>());

        int count = VisualTreeHelper.GetChildrenCount(root);
        for (int i = 0; i < count; i++)
        {
            n.Children.Add(BuildTree(VisualTreeHelper.GetChild(root, i)));
        }
        return n;
    }
}
