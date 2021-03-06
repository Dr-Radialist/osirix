/*=========================================================================
  Program:   OsiriX

  Copyright (c) OsiriX Team
  All rights reserved.
  Distributed under GNU - LGPL
  
  See http://www.osirix-viewer.com/copyright.html for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.
=========================================================================*/

#import "Notifications.h"

NSString* const OsirixUpdateWLWWMenuNotification = @"UpdateWLWWMenu";
NSString* const OsirixChangeWLWWNotification = @"changeWLWW";
NSString* const OsirixROIChangeNotification = @"roiChange";
NSString* const OsirixCloseViewerNotification = @"CloseViewerNotification";
NSString* const OsirixUpdate2dCLUTMenuNotification = @"Update2DCLUTMenu";
NSString* const OsirixUpdate2dWLWWMenuNotification = @"Update2DWLWWMenu";
NSString* const OsirixLLMPRResliceNotification = @"LLMPRReslice";
NSString* const OsirixROIVolumePropertiesChangedNotification = @"ROIVolumePropertiesChanged";
NSString* const OsirixVRViewDidBecomeFirstResponderNotification = @"VRViewDidBecomeFirstResponder";
NSString* const OsirixUpdateVolumeDataNotification = @"updateVolumeData";
NSString* const OsirixRevertSeriesNotification = @"revertSeriesNotification";
NSString* const OsirixOpacityChangedNotification = @"OpacityChanged";
NSString* const OsirixDefaultToolModifiedNotification = @"defaultToolModified";
NSString* const OsirixDefaultRightToolModifiedNotification = @"defaultRightToolModified";
NSString* const OsirixUpdateConvolutionMenuNotification = @"UpdateConvolutionMenu";
NSString* const OsirixCLUTChangedNotification = @"CLUTChanged";
NSString* const OsirixUpdateCLUTMenuNotification = @"UpdateCLUTMenu";
NSString* const OsirixUpdateOpacityMenuNotification = @"UpdateOpacityMenu";
NSString* const OsirixRecomputeROINotification = @"recomputeROI";
NSString* const OsirixStopPlayingNotification = @"notificationStopPlaying";
NSString* const OsirixChatBroadcastNotification = @"notificationiChatBroadcast";
NSString* const OsirixSyncSeriesNotification = @"notificationSyncSeries";
NSString* const OsirixReportModeChangedNotification = @"reportModeChanged";
NSString* const OsirixDeletedReportNotification = @"OsirixDeletedReport";
NSString* const OsirixServerArrayChangedNotification = @"OsiriXServerArray has changed";
NSString* const OsirixStudyAnnotationsChangedNotification = @"OsirixStudyAnnotationsChanged";
NSString* const OsirixGLFontChangeNotification = @"changeGLFontNotification";
NSString* const OsirixAddToDBNotification = @"OsirixAddToDBNotification";
NSString* const OsirixDicomDatabaseDidChangeContextNotification = @"OsirixDicomDatabaseDidChangeContextNotification";
#define OsiriXAddToDBArrayKey @"OsiriXAddToDBArray"
NSString* const OsirixAddToDBNotificationImagesArray = OsiriXAddToDBArrayKey;
NSString* const OsirixAddToDBCompleteNotification = @"OsirixAddToDBCompleteNotification";
NSString* const OsirixAddToDBCompleteNotificationImagesArray = OsiriXAddToDBArrayKey; // is deprecated in favor of OsirixAddToDBNotificationImagesArray
NSString* const _O2AddToDBAnywayNotification = @"_O2AddToDBAnywayNotification";
NSString* const _O2AddToDBAnywayCompleteNotification = @"_O2AddToDBAnywayCompleteNotification";
NSString* const O2DatabaseInvalidateAlbumsCacheNotification = @"InvalidateAlbumsCache";
NSString* const OsirixDatabaseObjectsMayBecomeUnavailableNotification = @"OsirixDatabaseObjectsMayBecomeUnavailableNotification";
NSString* const OsirixNewStudySelectedNotification = @"NewStudySelectedNotification";
NSString* const OsirixDidLoadNewObjectNotification = @"OsiriX Did Load New Object";
NSString* const OsirixRTStructNotification = @"RTSTRUCTNotification";
NSString* const OsirixAlternateButtonPressedNotification = @"AlternateButtonPressed";
NSString* const OsirixROISelectedNotification = @"roiSelected";
NSString* const OsirixRemoveROINotification = @"removeROI";
NSString* const OsirixROIRemovedFromArrayNotification = @"roiRemovedFromArray";
NSString* const OsirixChangeFocalPointNotification = @"changeFocalPoint";
NSString* const OsirixWindow3dCloseNotification = @"Window3DClose";
NSString* const OsirixDisplay3dPointNotification = @"Display3DPoint";
NSString* const OsirixPluginDownloadInstallDidFinishNotification = @"PluginManagerControllerDownloadAndInstallDidFinish";
NSString* const OsirixXMLRPCMessageNotification = @"OsiriXXMLRPCMessage";
NSString* const OsirixDragMatrixImageMovedNotification = @"DragMatrixImageMoved";
NSString* const OsirixNotification = @"VRCameraDidChange";
NSString* const OsiriXFileReceivedNotification = @"OsiriXFileReceivedNotification";
NSString* const OsirixDCMSendStatusNotification = @"DCMSendStatus";
NSString* const OsirixDCMUpdateCurrentImageNotification = @"DCMUpdateCurrentImage";
NSString* const OsirixDCMViewIndexChangedNotification = @"DCMViewIndexChanged";
NSString* const OsirixRightMouseUpNotification = @"PLUGINrightMouseUp";
NSString* const OsirixMouseDownNotification = @"mouseDown";
NSString* const OsirixVRCameraDidChangeNotification = @"VRCameraDidChange";
NSString* const OsirixSyncNotification = @"sync";
NSString* const OsirixAddROINotification = @"addROI";
NSString* const OsirixRightMouseDownNotification = @"PLUGINrightMouseDown";
NSString* const OsirixRightMouseDraggedNotification = @"PLUGINrightMouseDragged";
NSString* const OsirixLabelGLFontChangeNotification = @"changeLabelGLFontNotification";
NSString* const OsirixDrawTextInfoNotification = @"PLUGINdrawTextInfo";
NSString* const OsirixDrawObjectsNotification = @"PLUGINdrawObjects";
NSString* const OsirixDCMViewDidBecomeFirstResponderNotification = @"DCMViewDidBecomeFirstResponder";
NSString* const OsirixPerformDragOperationNotification = @"PluginDragOperationNotification";
NSString* const OsirixViewerWillChangeNotification = @"ViewerWillChangeNotification";
NSString* const OsirixViewerDidChangeNotification = @"ViewerDidChangeNotification";
NSString* const OsirixUpdateViewNotification = @"updateView";
NSString* const OsirixViewerControllerDidLoadImagesNotification = @"OsirixViewerControllerDidLoadImagesNotification";
NSString* const OsirixViewerControllerWillFreeVolumeDataNotification = @"OsirixViewerControllerWillFreeVolumeDataNotification"; // userinfo dict will contain an NSData with @"volumeData" key and a NSNumber with @"movieIndex" key
NSString* const OsirixViewerControllerDidAllocateVolumeDataNotification = @"OsirixViewerControllerDidAllocateVolumeDataNotification"; // userinfo dict will contain an NSData with @"volumeData" key and a NSNumber with @"movieIndex" key
NSString* const KFSplitViewDidCollapseSubviewNotification = @"KFSplitViewDidCollapseSubviewNotification";
NSString* const KFSplitViewDidExpandSubviewNotification = @"KFSplitViewDidExpandSubviewNotification";
NSString* const BLAuthenticatedNotification = @"BLAuthenticatedNotification";
NSString* const BLDeauthenticatedNotification = @"BLDeauthenticatedNotification";

NSString* const OsirixActiveLocalDatabaseDidChangeNotification = @"OsirixActiveLocalDatabaseDidChangeNotification";

NSString* const OsirixPopulatedContextualMenuNotification = @"OsirixPopulatedContextualMenuNotification";
NSString* const OsiriXLogEvent = @"OsiriXLogEvent";

NSString* const OsirixNodeAdded2CurvePathNotification = @"OsirixNodeAdded2CurvePath";
NSString* const OsirixNodeRemovedFromCurvePathNotification = @"OsirixNodeRemovedFromCurvePath";
