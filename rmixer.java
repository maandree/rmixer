import java.io.*;
import java.net.*;
import java.util.*;


public class rmixer
{
    public static void main(final String... _args) throws Exception
    {
	String[] args = _args;
	
	String home, fs;
	home = (home = System.getenv().get("HOME")) == null ? System.getProperty("user.home") : home;
        fs = (fs = System.getProperty("file.separator")) == null ? "/" : fs;
	if (home.endsWith(fs) == false)  home += fs;
	
	if ((new File(home + ".rmixerrc")).exists())
	{
	    String buf = "";
	    final InputStream is = new BufferedInputStream(new FileInputStream(new File(home + ".rmixerrc")));
	    final Scanner sc = new Scanner(is);
	    while (sc.hasNextLine())
		buf += " " + sc.nextLine();
	    is.close();
	    while (buf.contains("        "))  buf = buf.replace("        " , " ");
	    while (buf.contains("    "))  buf = buf.replace("    " , " ");
	    while (buf.contains("  "))  buf = buf.replace("  " , " ");
	    if (buf.startsWith(" "))    buf = buf.substring(1);
	    if (buf.endsWith(" "))      buf = buf.substring(0, buf.length() - 1);
	    
	    if (buf.isEmpty() == false)
	    {
		final String[] xargs = buf.split(" ");
		final String[] nargs = new String[xargs.length + args.length];
		System.arraycopy(xargs, 0, nargs, 0, xargs.length);
		System.arraycopy(args, 0, nargs, xargs.length, args.length);
		args = nargs;
	    }
	}
	
	String client = null;
	boolean server = false;
	int action = -1;
        int port = -1;
	int prec = -1;
	try
	{   for (int i = 0, n = args.length; i < n; i++)
		if (args[i].equals("--server"))
		{   server = true;
		    prec = 1;
		}
		else if (args[i].equals("--client"))
		{   client = args[++i];
		    prec = 0;
		}
		else if (args[i].equals("--port"))
		    port = Integer.parseInt(args[++i]);
		else if (args[i].equals("+"))
		    prec = action = 0;
		else if (args[i].equals("-"))
		{   action = 1;
		    prec = 0;
		}
		else if (args[i].equals("0") || args[i].equals("m"))
		{   action = 2;
		    prec = 0;
		}
		else
		    throw new Exception();
	    if (prec < 0)  throw new Exception();
	    if (port < 0)  throw new Exception();
	    if ((client == null) && (prec == 0))  throw new Exception();
	    if ((action < 0) && (prec == 0))  throw new Exception();
	}
	catch (final Throwable err)
	{
	    System.out.println("rmixer - Simple remote interface for the ALSA mixer");
	    System.out.println();
	    System.out.println("USAGE:  rmixer OPTIONS [ACTION]");
	    System.out.println();
	    System.out.println("Omitted options and arguments are read from ~/.rmixerrc");
	    System.out.println("Last appliced option at conflict takes precidence");
	    System.out.println();
	    System.out.println("OPTIONS:");
	    System.out.println();
	    System.out.println("   --client ADDRESS    Specificy the remote computer to access");
	    System.out.println("   --server            Specificy to set up server for remote access");
	    System.out.println("   --port PORT         Specificy the port the server uses (yours or accessed)");
	    System.out.println();
	    System.out.println("   --port must be used as well as either --client or --server.");
	    System.out.println();
	    System.out.println("ACTIONS:");
	    System.out.println();
	    System.out.println("   Actions are only applicable at remote access (--client),");
	    System.out.println("   in which case it must be used.");
	    System.out.println();
	    System.out.println("   +           Increase PCM volume by 3dB");
	    System.out.println("   -           Decrease PCM volume by 3dB");
	    System.out.println("   0    m      Set PCM volume to zero (-51dB)");
	    System.out.println();
	    System.out.println();
	    System.out.println();
	    return;
	}
	
	if (prec == 0)
	{
	    System.out.print("(amixer -c 0 -- set PCM) ");
	    if (action == 0)  System.out.print("3dB+");
	    if (action == 1)  System.out.print("3dB-");
	    if (action == 2)  System.out.print("0");
	    System.out.println(" >> [" + client + "]:" + port);
	    try
	    {
		final Socket sock = new Socket(InetAddress.getByName(client), port);
		final PrintStream out = new PrintStream(sock.getOutputStream());
		if (action == 0)  out.println("3dB+");
		if (action == 1)  out.println("3dB-");
		if (action == 2)  out.println("0");
		out.flush();
		sock.close();
		System.out.println("SUCCESS");
	    }
	    catch (final Throwable err)
	    {   System.out.println("FAILURE");
		err.printStackTrace(System.err);
	    }
	}
	else
	{
	    final ServerSocket servsock = new ServerSocket(port);
	    for (;;)
	    {
		final Socket socket = servsock.accept();
	        (new Thread()
		    {
			@Override
			public void run()
			{   try
			    {   final Scanner sc = new Scanner(socket.getInputStream());
				while (sc.hasNextLine())
				    rmixer.exec(sc.nextLine());
				socket.close();
			    }
			    catch (final Throwable err)
				{ /* ignore */ }
		     }   }).start();
	    }
	}
    }
    
    public static void exec(final String arg) throws Throwable
    {
	final ProcessBuilder procBuilder = new ProcessBuilder("amixer", "-c", "0", "--", "set", "PCM", arg);
	procBuilder.inheritIO();
	procBuilder.start();
    }

}

