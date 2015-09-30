package com.tapsense.adapters;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.os.Bundle;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.mediation.MediationAdRequest;
import com.google.android.gms.ads.mediation.customevent.CustomEventInterstitial;
import com.google.android.gms.ads.mediation.customevent.CustomEventInterstitialListener;
import com.tapsense.android.publisher.TSErrorCode;
import com.tapsense.android.publisher.TSKeywordMap;
import com.tapsense.android.publisher.TapSenseAds;
import com.tapsense.android.publisher.TapSenseInterstitial;
import com.tapsense.android.publisher.TapSenseInterstitialListener;

public class TapSenseAdMobInterstitialAdapter implements
    CustomEventInterstitial, TapSenseInterstitialListener {

  private CustomEventInterstitialListener mInterstitialListener;
  private TapSenseInterstitial mInterstitial;

  /**
   * {@link CustomEventInterstitial} methods
   */

  @Override
  public void requestInterstitialAd(Context context,
      CustomEventInterstitialListener listener, String serverParameter,
      MediationAdRequest mediationAdRequest, Bundle customEventExtras) {
    try {
      // Remove test mode before going live and submitting to Play Store
      TapSenseAds.setTestMode();

      mInterstitialListener = listener;

      JSONObject serverParameterJson = new JSONObject(serverParameter);

      mInterstitial = new TapSenseInterstitial(context,
          serverParameterJson.getString("ad_unit_id"), false,
          TSKeywordMap.EMPTY_TS_KEYWORD_MAP);
      mInterstitial.setListener(this);
      mInterstitial.requestAd();
    } catch (JSONException e) {
      listener.onAdFailedToLoad(AdRequest.ERROR_CODE_INVALID_REQUEST);
    }
  }

  @Override
  public void showInterstitial() {
    if (mInterstitial != null && mInterstitial.isReady()) {
      mInterstitial.showAd();
    }
  }

  @Override
  public void onDestroy() {
    if (mInterstitial != null) {
      mInterstitial.destroy();
    }
  }

  @Override
  public void onPause() {

  }

  @Override
  public void onResume() {

  }

  /**
   * {@link TapSenseInterstitialListener} methods
   * 
   * Note: {@link TapSenseInterstitialListener} does not have an equivalent of
   * {@link CustomEventInterstitialListener#onAdClicked} or
   * {@link CustomEventInterstitialListener#onAdLeftApplication}
   */

  @Override
  public void onInterstitialLoaded(TapSenseInterstitial interstitial) {
    if (mInterstitialListener != null) {
      mInterstitialListener.onAdLoaded();
    }

  }

  @Override
  public void onInterstitialFailedToLoad(TapSenseInterstitial interstitial,
      TSErrorCode errorCode) {
    if (mInterstitialListener != null) {
      switch (errorCode) {
      case INVALID_AD_SIZE:
      case INVALID_AD_UNIT_ID:
        mInterstitialListener
            .onAdFailedToLoad(AdRequest.ERROR_CODE_INVALID_REQUEST);
        break;
      case NO_FILL:
        mInterstitialListener.onAdFailedToLoad(AdRequest.ERROR_CODE_NO_FILL);
        break;
      case NO_INTERNET:
        mInterstitialListener
            .onAdFailedToLoad(AdRequest.ERROR_CODE_NETWORK_ERROR);
        break;
      default:
        mInterstitialListener
            .onAdFailedToLoad(AdRequest.ERROR_CODE_INTERNAL_ERROR);
        break;
      }
    }
  }

  @Override
  public void onInterstitialShown(TapSenseInterstitial interstitial) {
    if (mInterstitialListener != null) {
      mInterstitialListener.onAdOpened();
    }
  }

  @Override
  public void onInterstitialDismissed(TapSenseInterstitial interstitial) {
    if (mInterstitialListener != null) {
      mInterstitialListener.onAdClosed();
    }
  }

}
