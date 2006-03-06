/*=========================================================================
Program:   OsiriX

Copyright (c) OsiriX Team
All rights reserved.
Distributed under GNU - GPL

See http://homepage.mac.com/rossetantoine/osirix/copyright.html for details.

This software is distributed WITHOUT ANY WARRANTY; without even
the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.
=========================================================================*/


#ifndef __itkMSRGFilter_txx_
#define __itkMSRGFilter_txx_

#include <queue>
#include <vector>
#include <itkMatrix.h>
#include "vnl/vnl_math.h"
#include "itkConnectedComponentImageFilter.h"
#include "itkImageLinearConstIteratorWithIndex.h"
#include "itkMinimumMaximumImageCalculator.h"
#include "itkConstNeighborhoodIterator.h"
#include "itkMeanCalculator.h"
#include "itkCovarianceCalculator.h"
#include "itkMahalanobisDistanceMembershipFunction.h"
#include "itkSubtractImageFilter.h"
#include "itkVector.h"
#include "itkListSample.h"
#include "itkProgressReporter.h"
#include "SeedMSRG.h"
#include "itkListSample.h"
#include "itkMeanCalculator.h"
#include "MSRGImageHelper.h"
#include "MorphoHelper.h"
#include "itkMSRGFilter.h"
//#include "itkImageFileWriter.h"

using namespace std;
namespace itk
{
	template < class TInputImage > MSRGFilter < TInputImage >::MSRGFilter ()
{
		// default value
		labelMarker=false;
		// TODO initialiser m_Marker
		//m_Upper = NumericTraits < InputImagePixelType >::max ();
}

template < class TInputImage > void MSRGFilter < TInputImage >::PrintSelf (std::ostream & os, Indent indent) const
{
    this->Superclass::PrintSelf (os, indent);
}

template < class TInputImage > void MSRGFilter < TInputImage >::GenerateInputRequestedRegion ()
{
    Superclass::GenerateInputRequestedRegion ();
    if (this->GetInput ())
	{
		InputImagePointer image = const_cast < InputImageType * >(this->GetInput ());
		image->SetRequestedRegionToLargestPossibleRegion ();
	}
}

template < class TInputImage > void MSRGFilter < TInputImage >::EnlargeOutputRequestedRegion (DataObject * output)
{
    Superclass::EnlargeOutputRequestedRegion (output);
    output->SetRequestedRegionToLargestPossibleRegion ();
}


template < class TInputImage > void MSRGFilter < TInputImage >::GenerateData ()
{
	std::cout << "Inside MSRG Algorithm ..." << std::endl;
    InputImageConstPointer m_Criteria = this->GetInput ();
    OutputImagePointer outputImage = this->GetOutput ();
    //unsigned long outputImageDataSize = outputImage->GetPixelContainer()->Size();
	
    // *************************************************************
    // *                INIT        IMAGES                         *
    // *************************************************************  
	
	
    // Zero the output
    OutputImageRegionType region = outputImage->GetRequestedRegion ();
    outputImage->SetBufferedRegion (region);
    outputImage->Allocate ();
 	
    // init status - 0 empty, 1 permanent, 2 in queue
	OutputImagePointer statusImage = OutputImageType::New ();
	statusImage->SetRegions(region);
	statusImage->Allocate();
	statusImage->FillBuffer (NumericTraits < OutputImagePixelType >::Zero);
	
	
    // *************************************************************
    // *                REGION INIT                                *
    // *************************************************************  
	
	OutputImagePointer relabelMarker;
	// Do we need to relabel the image markers ?
	if (labelMarker)
	{
		relabelMarker=MorphoHelper<OutputImageType>::LabelImage(m_Marker);
		m_Marker=relabelMarker;
	}
	int NumberOfRegions=static_cast<int>(MSRGImageHelper<OutputImageType>::GetImageMax(m_Marker));
	std::cout << "NumberOfRegions=" << NumberOfRegions << std::endl;
	
	
	// *************************************************************
    // *                MEAN and COV EXTRACTION                    *
    // *************************************************************  
	
	
	typedef typename  itk::Statistics::ListSample< CriteriaImagePixelType > SampleType;
	typedef typename SampleType::Pointer SamplePointerType;
	SamplePointerType *SRGSample = new SamplePointerType[NumberOfRegions];
	
	for( int i=0; i<NumberOfRegions; i++ )
		SRGSample[i]  = SampleType::New();
	
	typedef typename itk::ImageRegionConstIterator< OutputImageType > ConstOutputIteratorType;
	typedef typename itk::ImageRegionConstIterator< InputImageType>  ConstCriteriaIteratorType;
	ConstOutputIteratorType inputMarkerIt( m_Marker, m_Marker->GetRequestedRegion ()  );
	ConstCriteriaIteratorType  inputCriteriaIt(  m_Criteria, m_Criteria->GetRequestedRegion() );
	OutputImagePixelType label;
	
	// find samples for all regions...
	for ( inputMarkerIt.GoToBegin(), inputCriteriaIt.GoToBegin(); !inputMarkerIt.IsAtEnd();
		  ++inputMarkerIt, ++inputCriteriaIt)
	{
		label=inputMarkerIt.Get();
		if (label!=0)
			SRGSample[static_cast<int>(label)-1]->PushBack( inputCriteriaIt.Get() );
	}
	
	// Mean
	typedef typename itk::Statistics::MeanCalculator< SampleType > MeanAlgorithmType;
	typedef typename MeanAlgorithmType::Pointer MeanPointerType;
	MeanPointerType* meanAlgorithm = new MeanPointerType[NumberOfRegions];
	for (int i=0;i<NumberOfRegions;i++){
		meanAlgorithm[i] = MeanAlgorithmType::New();
		meanAlgorithm[i]->SetInputSample( SRGSample[i]);
		meanAlgorithm[i]->Update();	
		std::cout << "Mean  Vector :" << *(meanAlgorithm[i]->GetOutput()) << std::endl;
	}
	
	// Covariance
	
	typedef typename itk::Statistics::CovarianceCalculator< SampleType > CovarianceAlgorithmType;
	typedef typename CovarianceAlgorithmType::Pointer CovariancePointerType;
	CovariancePointerType *covarianceAlgorithm = new CovariancePointerType[NumberOfRegions];
	for (int i=0;i<NumberOfRegions;i++){
		covarianceAlgorithm[i]= CovarianceAlgorithmType::New();
		covarianceAlgorithm[i]->SetInputSample( SRGSample[i] );
		covarianceAlgorithm[i]->SetMean( meanAlgorithm[i]->GetOutput() );
		covarianceAlgorithm[i]->Update();
		std::cout << "Covariance Matrix :\n" << *(covarianceAlgorithm[i]->GetOutput()) << std::endl;
	}
	
	
    //  Extract only the rings of the regions 
	// *************************************************************
	// *               SEEDS EXTRACTION                            *
	// *************************************************************  
	
	
	// extract initial solution (user markers)
	 OutputImagePointer erodMarker=MorphoHelper<OutputImageType>::ErodeImageByRadius(m_Marker,1);
	 
	 typedef typename itk::ImageRegionIterator< OutputImageType > OutputIteratorType;
	 
	 ConstOutputIteratorType erodMarkerIt( erodMarker, erodMarker->GetRequestedRegion ()  );
	 OutputIteratorType outputImageIt1( outputImage, outputImage->GetRequestedRegion ()  );
	
	 for ( erodMarkerIt.GoToBegin(), outputImageIt1.GoToBegin(); !erodMarkerIt.IsAtEnd();
	 	  ++outputImageIt1, ++erodMarkerIt)
	 {
		outputImageIt1.Set(erodMarkerIt.Get());
	}
	 /*
	 OutputImagePixelType* importPointer = erodMarker->GetPixelContainer()->GetBufferPointer();
	 OutputImagePixelType* bufferPointer = outputImage->GetPixelContainer()->GetBufferPointer();
	 memcpy(bufferPointer, importPointer, outputImageDataSize*sizeof(OutputImagePixelType));
	*/
	// set status values to permanent 
	
	ConstOutputIteratorType outputImageIt( outputImage, outputImage->GetRequestedRegion ()  );
	OutputIteratorType statusIt( statusImage, statusImage->GetRequestedRegion ()  );
	for ( outputImageIt.GoToBegin(), statusIt.GoToBegin(); !outputImageIt.IsAtEnd();
		  ++outputImageIt, ++statusIt)
	{
		if (outputImageIt.Get()!=0)
			statusIt.Set(1); // permanent
	}
	
	// remove these points from the initial markerImage, so we will just have the ring of the region => (the inputs seeds for the PQ)	
	typedef typename itk::SubtractImageFilter<OutputImageType,OutputImageType,OutputImageType> SubtractFilterType;
	typename SubtractFilterType::Pointer subtractFilter = SubtractFilterType::New();
	subtractFilter->SetInput1(m_Marker);	
	subtractFilter->SetInput2(outputImage);	
	subtractFilter->Update();
	m_Marker=subtractFilter->GetOutput();
	
	
	// *************************************************************
	// *                PRIORITY QUEUE INIT                        *
	// *************************************************************  
	
	
	typedef typename itk::Statistics::MahalanobisDistanceMembershipFunction< CriteriaImagePixelType > MahalanobisDistanceMembershipFunctionType;
	typename MahalanobisDistanceMembershipFunctionType::Pointer MahalanobisDistance = MahalanobisDistanceMembershipFunctionType::New();
	typedef typename itk::ImageLinearConstIteratorWithIndex < OutputImageType > ConstIteratorWithIndexType;
	ConstIteratorWithIndexType inputIt (m_Marker, m_Marker->GetRequestedRegion ());
	typedef SeedMSRG < IndexOutputType, double > seedType;    
	priority_queue < seedType, vector < seedType >, seedType > PQ;
	seedType seed;
	
	for (inputIt.GoToBegin (); !inputIt.IsAtEnd (); inputIt.NextLine ())
	{
		inputIt.GoToBeginOfLine ();
		while (!inputIt.IsAtEndOfLine ())
		{
			label=inputIt.Get ();
			if (label!=0)
			{
				seed.index = inputIt.GetIndex ();
				seed.label = inputIt.Get ();
				statusImage->SetPixel(seed.index,2); // in queue				
				MahalanobisDistance->SetMean(*(meanAlgorithm[seed.label-1]->GetOutput()));				 
				MahalanobisDistance->SetCovariance(covarianceAlgorithm[seed.label-1]->GetOutput()->GetVnlMatrix());
				seed.distance=MahalanobisDistance->Evaluate(m_Criteria->GetPixel(seed.index));
				PQ.push (seed);
			}
			++inputIt;
		}
	}  
	
	
	// *************************************************************
	// *                      MAIN                                 *
	// *************************************************************  
	
	
	typedef typename itk::ConstNeighborhoodIterator < OutputImageType > NeighborhoodIteratorType;
	typename NeighborhoodIteratorType::RadiusType radius;
	radius.Fill (1);
	NeighborhoodIteratorType it (radius, m_Marker, m_Marker->GetRequestedRegion ());
	OutputImagePixelType w;
	seedType pi;
	IndexOutputType piIndex, qiIndex;
	bool boundary = false;
	
	while (!PQ.empty ())
	{
		pi = PQ.top ();
		PQ.pop ();
		piIndex = pi.index;
		statusImage->SetPixel (piIndex, 1);
		outputImage->SetPixel (piIndex, pi.label);	// propagate label
		//m_Marker->SetPixel (piIndex, pi.label);
		it.SetLocation (piIndex);
		for (unsigned i = 0; i < it.Size (); i++)
		{
			w = it.GetPixel (i, boundary); 
			if (boundary)
			{		
				qiIndex = it.GetIndex (i);		
				if (statusImage->GetPixel (qiIndex) == 0) 
				{
					seed.index = qiIndex;
					seed.label = pi.label;
					statusImage->SetPixel (seed.index, 2);
					MahalanobisDistance->SetMean(*(meanAlgorithm[seed.label-1]->GetOutput()));
					MahalanobisDistance->SetCovariance(covarianceAlgorithm[seed.label-1]->GetOutput()->GetVnlMatrix());
					seed.distance=MahalanobisDistance->Evaluate(m_Criteria->GetPixel(seed.index));	
					PQ.push (seed);					
				}
			}
		}
		
	}
	/*
	typedef typename itk::ImageFileWriter < OutputImageType > WriterType;
	typename WriterType::Pointer writer = WriterType::New ();
	writer->SetFileName ("/Users/arg/Desktop/result.png");
	writer->SetInput (outputImage);
	writer->Update();*/
}


}
// end namespace itk

#endif
