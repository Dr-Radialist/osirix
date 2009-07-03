//
//  NSUtils.mm
//  Arthroplasty Templating II
//
//  Created by Alessandro Volz on 6/25/09.
//  Copyright 2009 HUG. All rights reserved.
//

#import "NSUtils.h"
#include <cmath>


NSString* NoInterceptionException = @"NoInterceptionException";


// CGFloat

CGFloat NSSign(CGFloat f) {
	return f<0? -1 : 1;
}


/// NSSize

NSSize operator-(const NSSize& s) {
	return NSMakeSize(-s.width, -s.height);
}

NSSize operator+(const NSSize& s1, const NSSize& s2) {
	return NSMakeSize(s2.width+s1.width, s2.height+s1.height);
}

NSSize operator-(const NSSize& s1, const NSSize& s2) {
	return s1+(-s2);
}

NSSize operator*(const NSSize& s1, const NSSize& s2) {
	return NSMakeSize(s1.width*s2.width, s1.height*s2.height);
}

NSSize operator/(const NSSize& s1, const NSSize& s2) {
	return s1*(1/s2);
}

BOOL operator==(const NSSize& s1, const NSSize& s2) {
	return (s1.width==s2.width) && (s1.height==s2.height);
}

BOOL operator!=(const NSSize& s1, const NSSize& s2) {
	return !(s1==s2);
}

// NSSize & CGFloat

NSSize operator+(const NSSize& s, const CGFloat f) {
	return NSMakeSize(s.width+f, s.height+f);
}

NSSize operator*(const CGFloat f, const NSSize& s) {
	return NSMakeSize(f*s.width, f*s.height);
}

NSSize operator/(const CGFloat f, const NSSize& s) {
	return NSMakeSize(f/s.width, f/s.height);
}

NSSize operator*(const NSSize& s, const CGFloat f) {
	return f*s;
}

NSSize operator/(const NSSize& s, const CGFloat f) {
	return s*(1/f);
}


/// NSPoint

NSPoint operator-(const NSPoint& p) {
	return NSMakePoint(-p.x, -p.y);
}

NSPoint operator+(const NSPoint& p1, const NSPoint& p2) {
	return NSMakePoint(p2.x+p1.x, p2.y+p1.y);
}

NSPoint operator-(const NSPoint& p1, const NSPoint& p2) {
	return p1+(-p2);
}

NSPoint operator*(const NSPoint& p1, const NSPoint& p2) {
	return NSMakePoint(p1.x*p2.x, p1.y*p2.y);
}

NSPoint operator/(const NSPoint& p1, const NSPoint& p2) {
	return p1*(1/p2);
}

BOOL operator==(const NSPoint& p1, const NSPoint& p2) {
	return (p1.x==p2.x) && (p1.y==p2.y);
}

BOOL operator!=(const NSPoint& p1, const NSPoint& p2) {
	return !(p1==p2);
}

// NSPoint & CGFloat

NSPoint operator*(const CGFloat f, const NSPoint& p) {
	return NSMakePoint(f*p.x, f*p.y);
}

NSPoint operator/(const CGFloat f, const NSPoint& p) {
	return NSMakePoint(f/p.x, f/p.y);
}

NSPoint operator*(const NSPoint& p, const CGFloat f) {
	return f*p;
}

NSPoint operator/(const NSPoint& p, const CGFloat f) {
	return p*(1/f);
}

// NSPoint & NSSize

NSPoint NSMakePoint(const NSSize& s) {
	return NSMakePoint(s.width, s.height);
}

NSSize operator+(const NSSize& s, const NSPoint& p) {
	return NSMakeSize(p.x+s.width, p.y+s.height);
}

NSPoint operator+(const NSPoint& p, const NSSize& s) {
	return NSMakePoint(p.x+s.width, p.y+s.height);
}

NSSize operator-(const NSSize& s, const NSPoint& p) {
	return s+(-p);
}

NSPoint operator-(const NSPoint& p, const NSSize& s) {
	return p+(-s);
}

NSSize operator*(const NSSize& s, const NSPoint& p) {
	return NSMakeSize(p.x*s.width, p.y*s.height);
}

NSPoint operator*(const NSPoint& p, const NSSize& s) {
	return NSMakePoint(p.x*s.width, p.y*s.height);
}

NSSize operator/(const NSSize& s, const NSPoint& p) {
	return s*(1/p);
}

NSPoint operator/(const NSPoint& p, const NSSize& s) {
	return p*(1/s);
}


/// NSVector

NSVector NSMakeVector(CGFloat x, CGFloat y) {
	NSVector vector;
	vector.x = x;
	vector.y = y;
	return vector;
}

NSVector NSMakeVector(const NSPoint& p1, const NSPoint& p2) {
	return NSMakeVector(p2.x-p1.x, p2.y-p1.y);
}

NSVector NSMakeVector(const NSPoint& p) {
	return NSMakeVector(p.x, p.y);
}

NSPoint NSMakePoint(const NSVector& v) {
	return NSMakePoint(v.x, v.y);
}

NSVector operator!(const NSVector& v) {
	return NSMakeVector(-v.y, v.x);
}

CGFloat NSAngle(const NSVector& v) {
//	if (v.x == 0)
//		return -pi/2*NSSign(v.y);
	return atan2f(v.y, v.x);
}

CGFloat NSLength(const NSVector& v) {
	return std::sqrt(std::pow(v.x, 2)+std::pow(v.y, 2));
}

// other

CGFloat NSDistance(const NSPoint& p1, const NSPoint& p2) {
	return NSLength(NSMakeVector(p1, p2));
}

CGFloat NSAngle(const NSPoint& p1, const NSPoint& p2) {
	return NSAngle(NSMakeVector(p1, p2));
}

NSPoint NSMiddle(const NSPoint& p1, const NSPoint& p2) {
	return (p1+p2)/2;
}


/// NSLine

NSLine NSMakeLine(const NSPoint& origin, const NSVector& direction) {
	NSLine line;
	line.origin = origin;
	line.direction = direction;
	return line;
}

NSLine NSMakeLine(const NSPoint& p1, const NSPoint& p2) {
	return NSMakeLine(p1, NSMakeVector(p1, p2));
}

CGFloat NSAngle(const NSLine& l) {
	return NSAngle(l.direction);
}

BOOL NSParallel(const NSLine& l1, const NSLine& l2) {
	return NSAngle(l1) == NSAngle(l2);
}

NSPoint operator*(const NSLine& l1, const NSLine& l2) {
	if (NSParallel(l1, l2))
		[NSException raise:NoInterceptionException format:@"The two lines are parallel and therefore have no interception."];
	CGFloat u = (l2.direction.x*(l1.origin.y-l2.origin.y)-l2.direction.y*(l1.origin.x-l2.origin.x))/(l2.direction.y*l1.direction.x-l2.direction.x*l1.direction.y);
	return NSMakePoint(l1.origin.x+u*l1.direction.x, l1.origin.y+u*l1.direction.y);
}
