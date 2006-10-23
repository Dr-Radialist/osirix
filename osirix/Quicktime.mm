#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>

// WHY THIS EXTERNAL APPLICATION FOR QUICKTIME?

// 64-bits apps support only very basic Quicktime API
// Quicktime is not multi-thread safe: highly recommended to use it only on the main thread

int main(int argc, const char *argv[])
{
	NSAutoreleasePool	*pool	= [[NSAutoreleasePool alloc] init];
	
	EnterMovies();
	
	//	argv[ 1] : what to do?
	//	argv[ 2] : Path for Quicktime file
		
	if( argv[ 1] && argv[ 2])
	{
		NSString	*what = [NSString stringWithCString:argv[ 1]];
		NSString	*path = [NSString stringWithCString:argv[ 2]];
		
		if( [what isEqualToString:@"getFrame"])
		{
			int			frameNo = [[NSString stringWithCString:argv[ 3]] intValue];
			NSImage		**result =(NSImage**) argv[ 4];
			
			QTMovie *movie = [[QTMovie alloc] initWithURL:[NSURL fileURLWithPath:path] error: 0L];
			
			if( movie)
			{
				int curFrame = 0;
				[movie gotoBeginning];
				
				QTTime previousTime;
				
				curFrame = 0;
				
				while( QTTimeCompare( previousTime, [movie currentTime]) == NSOrderedAscending && curFrame != frameNo)
				{
					previousTime = [movie currentTime];
					curFrame++;
					[movie stepForward];
				}
				
				*result = [movie currentFrameImage];
				
				[movie release];
			}
			
			ExitMoviesOnThread();
		}
	}
	
	
	ExitMovies();
	
	[pool release];
	
	return 0;
}
