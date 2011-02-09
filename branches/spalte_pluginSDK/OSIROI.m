//
//  OSIROI.m
//  OsiriX
//
//  Created by Joël Spaltenstein on 1/25/11.
//  Copyright 2011 OsiriX Team. All rights reserved.
//

#import "OSIROI.h"
#import "OSIROI+Private.h"
#import "OSIPlanarPathROI.h"
#import "OSICoalescedROI.h"
#import "OSIROIFloatPixelData.h"
#import "DCMView.h"
#import "N3Geometry.h"
#import "ROI.h"

@implementation OSIROI

- (NSString *)name
{
	assert(0);
	return nil;
}

- (NSArray *)convexHull
{
	assert(0);
	return nil;
}

- (OSIROIMask *)ROIMaskForFloatVolumeData:(OSIFloatVolumeData *)floatVolume
{
	return nil;
}

- (NSArray *)osiriXROIs
{
	return [NSArray array];
}

- (NSString *)label
{
	NSString *metric;
	NSMutableString *label;
	
	label = [NSMutableString string];
	for (metric in [self metricNames]) {
		[label appendFormat:@"%@: %@%@, ", [self labelForMetric:metric], [self valueForMetric:metric], [self unitForMetric:metric]];
	}
	return label;
}

- (NSArray *)metricNames
{
	return [NSArray arrayWithObjects:@"meanIntensity", @"maxIntensity", @"minIntensity", nil];
}

- (NSString *)labelForMetric:(NSString *)metric
{
	if ([metric isEqualToString:@"meanIntensity"]) {
		return @"Mean Intensity"; // localize me!
	} else if ([metric isEqualToString:@"maxIntensity"]) {
		return @"Maximum Intensity"; // localize me!
	} else if ([metric isEqualToString:@"minIntensity"]) {
		return @"Minimum Intensity"; // localize me!
	}
	return nil;
}

- (NSString *)unitForMetric:(NSString *)metric // make me smarter! this is not always HU values
{
	if ([metric isEqualToString:@"meanIntensity"]) {
		return @"HU";
	} else if ([metric isEqualToString:@"maxIntensity"]) {
		return @"HU"; 
	} else if ([metric isEqualToString:@"minIntensity"]) {
		return @"HU";
	}
	return nil;
}

- (id)valueForMetric:(NSString *)metric
{
	if ([metric isEqualToString:@"meanIntensity"]) {
		return [NSNumber numberWithDouble:[[self ROIFloatPixelData] meanIntensity]];
	} else if ([metric isEqualToString:@"maxIntensity"]) {
		return [NSNumber numberWithDouble:[[self ROIFloatPixelData] maxIntensity]];
	} else if ([metric isEqualToString:@"minIntensity"]) {
		return [NSNumber numberWithDouble:[[self ROIFloatPixelData] minIntensity]];
	}
	return nil;
}	

- (OSIROIFloatPixelData *)ROIFloatPixelData
{
	return [self ROIFloatPixelDataForFloatVolumeData:[self homeFloatVolumeData]];
}

- (OSIROIFloatPixelData *)ROIFloatPixelDataForFloatVolumeData:(OSIFloatVolumeData *)floatVolume; // convenience method
{
	return [[[OSIROIFloatPixelData alloc] initWithROIMask:[self ROIMaskForFloatVolumeData:floatVolume] floatVolumeData:floatVolume] autorelease];
}

- (OSIFloatVolumeData *)homeFloatVolumeData // the volume data on which the ROI was drawn
{
	return nil;
}

@end

@implementation OSIROI (Private)

+ (id)ROIWithOsiriXROI:(ROI *)roi pixToDICOMTransfrom:(N3AffineTransform)pixToDICOMTransfrom homeFloatVolumeData:(OSIFloatVolumeData *)floatVolumeData;
{
	switch ([roi type]) {
		case tMesure:
		case tOPolygon:
		case tCPolygon:
			return [[[OSIPlanarPathROI alloc] initWithOsiriXROI:roi pixToDICOMTransfrom:pixToDICOMTransfrom homeFloatVolumeData:floatVolumeData] autorelease];
			break;
		default:
			return nil;;
	}
}


+ (id)ROICoalescedWithOSIROIs:(NSArray *)rois
{
	return [[[OSICoalescedROI alloc] initWithOSIROIs:rois] autorelease];
}


@end
