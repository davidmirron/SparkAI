import React, { useState, useEffect } from 'react';
import { Camera, Heart, Sparkles, TrendingUp, Share2, Clock, X, ArrowRight, Loader, Zap, Users, Star, AlertCircle } from 'lucide-react';

const CoupleSparkAI = () => {
  const [currentScreen, setCurrentScreen] = useState('onboarding');
  const [selfieData, setSelfieData] = useState(null);
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [analysisResult, setAnalysisResult] = useState(null);
  const [hasShownPaywall, setHasShownPaywall] = useState(false);
  const [isSubscribed, setIsSubscribed] = useState(false);
  const [sharedToday, setSharedToday] = useState(false);

  // Simulated AI Analysis Results
  const aiAnalysisTemplates = [
    {
      sparkLevel: 3.2,
      status: "Roommate Mode 😴",
      diagnosis: "You're looking at each other like you're deciding who takes out the trash",
      urgentFix: "Kitchen Karaoke Battle",
      prescription: "Turn on your favorite throwback songs and have a 15-minute dance-off while making dinner. Loser does dishes. Winner gets a 5-minute massage.",
      viralChallenge: "Post your dance battle with #SparkAIChallenge",
      insight: "Couples who laugh together daily are 76% more likely to stay together"
    },
    {
      sparkLevel: 7.8,
      status: "Spark Detected 🔥",
      diagnosis: "That eye contact could melt steel beams",
      urgentFix: "Surprise Attack Date",
      prescription: "Right now, grab your partner and go get ice cream. Ask them the craziest place they want to travel. Book a hotel there for next month.",
      viralChallenge: "Film their reaction when you show the booking #SparkAISurprise",
      insight: "Spontaneous couples report 3x higher relationship satisfaction"
    },
    {
      sparkLevel: 5.5,
      status: "Comfort Zone Alert ⚠️",
      diagnosis: "You're together but your minds are in different time zones",
      urgentFix: "Phone Jail Challenge",
      prescription: "Lock both phones in a drawer for 2 hours. Play truth or dare with relationship questions. First person to check their phone owes the other a full body massage.",
      viralChallenge: "Time-lapse your 2-hour phone detox #SparkAIDetox",
      insight: "Couples spend only 4 minutes of quality time together daily"
    }
  ];

  const handleFileUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setSelfieData(reader.result);
        setCurrentScreen('analyzing');
        analyzeCoupleSelfie();
      };
      reader.readAsDataURL(file);
    }
  };

  const analyzeCoupleSelfie = () => {
    setIsAnalyzing(true);
    // Simulate AI processing
    setTimeout(() => {
      const randomResult = aiAnalysisTemplates[Math.floor(Math.random() * aiAnalysisTemplates.length)];
      setAnalysisResult(randomResult);
      setIsAnalyzing(false);
      setCurrentScreen('result');
    }, 3000);
  };

  const handleShare = () => {
    setSharedToday(true);
    // In real app, this would trigger native share
    alert("📸 Screenshot this result and share to your story with #SparkAI!");
  };

  const handleStartTrial = () => {
    setIsSubscribed(true);
    setCurrentScreen('camera');
  };

  // Onboarding Screen - Blake's "Did you hear about" principle
  if (currentScreen === 'onboarding') {
    return (
      <div className="min-h-screen bg-black text-white flex flex-col">
        <div className="flex-1 flex flex-col justify-center p-8">
          <div className="mb-8 mx-auto">
            <div className="relative">
              <Heart className="w-20 h-20 text-red-500 fill-red-500 animate-pulse" />
              <Sparkles className="w-8 h-8 text-yellow-400 absolute -top-2 -right-2" />
            </div>
          </div>
          
          <h1 className="text-4xl font-bold text-center mb-4">
            This AI Saved<br />
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-pink-500 to-purple-500">
              47,293 Relationships
            </span>
          </h1>
          
          <p className="text-xl text-center text-gray-300 mb-12">
            Take a selfie together.<br />
            AI analyzes your spark level.<br />
            Get your fix in 30 seconds.
          </p>

          <div className="space-y-4 mb-12">
            <div className="flex items-center space-x-3 bg-gray-900 rounded-2xl p-4">
              <div className="bg-green-500 rounded-full w-2 h-2 animate-pulse"></div>
              <p className="text-gray-300">
                <span className="text-white font-semibold">Sarah & Mike:</span> "We were heading for divorce. Now we can't keep our hands off each other"
              </p>
            </div>
            
            <div className="flex items-center space-x-3 bg-gray-900 rounded-2xl p-4">
              <div className="bg-green-500 rounded-full w-2 h-2 animate-pulse"></div>
              <p className="text-gray-300">
                <span className="text-white font-semibold">Jess & Tyler:</span> "The 2.3 spark score was a wake-up call. We're at 8.7 now!"
              </p>
            </div>
          </div>

          <button
            onClick={() => setCurrentScreen('paywall')}
            className="bg-gradient-to-r from-pink-500 to-purple-600 text-white rounded-full py-5 font-bold text-xl relative overflow-hidden group"
          >
            <span className="relative z-10">Analyze Your Relationship</span>
            <div className="absolute inset-0 bg-gradient-to-r from-purple-600 to-pink-500 transform scale-x-0 group-active:scale-x-100 transition-transform origin-left"></div>
          </button>
          
          <p className="text-center text-gray-500 text-sm mt-4">
            As seen on TikTok • 2.3M couples analyzed
          </p>
        </div>
      </div>
    );
  }

  // Paywall - Blake's principle: Less than a coffee date
  if (currentScreen === 'paywall') {
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-900 via-pink-900 to-black text-white flex flex-col">
        <div className="flex-1 flex flex-col justify-center p-8 max-w-md mx-auto w-full">
          <div className="text-center mb-8">
            <TrendingUp className="w-16 h-16 mx-auto mb-4 text-green-400" />
            <h2 className="text-3xl font-bold mb-2">
              Join the Top 1%<br />of Relationships
            </h2>
            <p className="text-xl text-gray-300">
              While others break up, you level up
            </p>
          </div>

          <div className="bg-white/10 backdrop-blur rounded-3xl p-6 mb-6 border border-white/20">
            <div className="space-y-4">
              <div className="flex items-start space-x-3">
                <div className="bg-green-500 rounded-full p-1 mt-1">
                  <Sparkles className="w-4 h-4 text-white" />
                </div>
                <div>
                  <p className="font-semibold">Daily AI Spark Analysis</p>
                  <p className="text-sm text-gray-300">Know exactly when you need to reconnect</p>
                </div>
              </div>
              
              <div className="flex items-start space-x-3">
                <div className="bg-green-500 rounded-full p-1 mt-1">
                  <Zap className="w-4 h-4 text-white" />
                </div>
                <div>
                  <p className="font-semibold">30-Second Relationship Fixes</p>
                  <p className="text-sm text-gray-300">AI prescribes exactly what to do right now</p>
                </div>
              </div>
              
              <div className="flex items-start space-x-3">
                <div className="bg-green-500 rounded-full p-1 mt-1">
                  <Star className="w-4 h-4 text-white" />
                </div>
                <div>
                  <p className="font-semibold">Viral Couple Challenges</p>
                  <p className="text-sm text-gray-300">Turn your love into social media gold</p>
                </div>
              </div>
            </div>
          </div>

          <div className="space-y-3 mb-6">
            <button
              onClick={handleStartTrial}
              className="w-full bg-white text-black rounded-full py-5 font-bold text-lg relative group overflow-hidden"
            >
              <span className="relative z-10">
                Start Free Week →
              </span>
              <div className="text-sm font-normal">Then $6.99/week</div>
            </button>
            
            <button
              onClick={handleStartTrial}
              className="w-full bg-white/20 backdrop-blur text-white rounded-full py-4 font-semibold border border-white/30"
            >
              Save 73% - $99/year
            </button>
          </div>

          <div className="text-center space-y-2">
            <p className="text-sm text-gray-400">
              Cancel anytime • 1 minute to set up
            </p>
            <p className="text-xs text-gray-500">
              Average couple spends $127/month on dates.<br />
              Spark AI costs less than one coffee date.
            </p>
          </div>
        </div>
      </div>
    );
  }

  // Camera Screen - The Core Mechanic
  if (currentScreen === 'camera') {
    return (
      <div className="min-h-screen bg-black flex flex-col">
        <div className="flex-1 relative">
          {/* Camera preview would go here */}
          <div className="absolute inset-0 bg-gradient-to-b from-transparent to-black/50">
            <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
              <div className="w-64 h-80 border-4 border-white rounded-3xl opacity-50"></div>
              <p className="text-white text-center mt-4 text-lg">
                Both faces must be visible
              </p>
            </div>
          </div>
          
          <div className="absolute top-8 left-0 right-0 text-center">
            <h2 className="text-white text-2xl font-bold">Take a Selfie Together</h2>
            <p className="text-gray-300 mt-2">Look at each other, not the camera</p>
          </div>
          
          <div className="absolute bottom-0 left-0 right-0 p-8">
            <label className="block">
              <input
                type="file"
                accept="image/*"
                capture="user"
                onChange={handleFileUpload}
                className="hidden"
              />
              <div className="bg-white rounded-full w-20 h-20 mx-auto flex items-center justify-center cursor-pointer active:scale-95 transition-transform">
                <Camera className="w-8 h-8 text-black" />
              </div>
            </label>
            <p className="text-white text-center mt-4 text-sm opacity-70">
              AI reads micro-expressions, eye contact, and body language
            </p>
          </div>
        </div>
      </div>
    );
  }

  // Analyzing Screen - Building anticipation
  if (currentScreen === 'analyzing') {
    return (
      <div className="min-h-screen bg-black flex flex-col items-center justify-center p-8">
        {selfieData && (
          <img 
            src={selfieData} 
            alt="Couple selfie" 
            className="w-48 h-48 rounded-3xl object-cover mb-8 opacity-50"
          />
        )}
        
        <div className="text-center">
          <Loader className="w-12 h-12 text-white animate-spin mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-white mb-2">
            AI is reading your chemistry...
          </h2>
          <div className="space-y-2 text-gray-400">
            <p className="animate-pulse">Analyzing eye contact patterns...</p>
            <p className="animate-pulse delay-75">Measuring smile synchronization...</p>
            <p className="animate-pulse delay-150">Detecting emotional distance...</p>
          </div>
        </div>
      </div>
    );
  }

  // Results Screen - The Viral Moment
  if (currentScreen === 'result' && analysisResult) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-900 via-pink-900 to-black text-white">
        {/* Shareable Result Card */}
        <div className="p-6">
          <div className="bg-white/10 backdrop-blur rounded-3xl p-6 border border-white/20">
            {selfieData && (
              <img 
                src={selfieData} 
                alt="Analyzed couple" 
                className="w-full h-48 rounded-2xl object-cover mb-4"
              />
            )}
            
            <div className="text-center mb-6">
              <h1 className="text-5xl font-bold mb-2">
                {analysisResult.sparkLevel}/10
              </h1>
              <div className="text-2xl font-semibold text-yellow-400 mb-2">
                {analysisResult.status}
              </div>
              <p className="text-gray-300">
                "{analysisResult.diagnosis}"
              </p>
            </div>
            
            {/* The Hook - Urgent Fix */}
            <div className="bg-red-500/20 border border-red-500 rounded-2xl p-4 mb-4">
              <div className="flex items-center space-x-2 mb-2">
                <AlertCircle className="w-5 h-5 text-red-400" />
                <h3 className="font-bold text-red-400">URGENT FIX REQUIRED</h3>
              </div>
              <h4 className="text-xl font-bold mb-2">{analysisResult.urgentFix}</h4>
              <p className="text-sm">{analysisResult.prescription}</p>
            </div>
            
            {/* Viral Challenge */}
            <div className="bg-purple-500/20 border border-purple-400 rounded-2xl p-4 mb-4">
              <h3 className="font-bold text-purple-400 mb-2">Today's Viral Challenge</h3>
              <p className="text-sm">{analysisResult.viralChallenge}</p>
            </div>
            
            {/* Insight */}
            <div className="text-center text-sm text-gray-400 mb-6">
              <p>💡 {analysisResult.insight}</p>
            </div>
            
            {/* Action Buttons */}
            <div className="space-y-3">
              <button
                onClick={handleShare}
                className="w-full bg-white text-black rounded-full py-4 font-bold flex items-center justify-center space-x-2"
              >
                <Share2 className="w-5 h-5" />
                <span>Share Your Spark Score</span>
              </button>
              
              {sharedToday && (
                <button
                  onClick={() => setCurrentScreen('camera')}
                  className="w-full bg-white/20 backdrop-blur text-white rounded-full py-4 font-bold border border-white/30"
                >
                  Check Again Tomorrow
                </button>
              )}
            </div>
          </div>
          
          {/* Social Proof */}
          <div className="mt-6 space-y-3">
            <div className="bg-white/5 rounded-2xl p-3 flex items-center space-x-3">
              <Users className="w-5 h-5 text-gray-400" />
              <p className="text-sm text-gray-300">
                <span className="text-white font-semibold">2,847 couples</span> improved their spark today
              </p>
            </div>
            
            <div className="bg-white/5 rounded-2xl p-3 flex items-center space-x-3">
              <TrendingUp className="w-5 h-5 text-green-400" />
              <p className="text-sm text-gray-300">
                Average spark increase: <span className="text-green-400 font-semibold">+4.3 points</span> in 30 days
              </p>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return null;
};

export default CoupleSparkAI;