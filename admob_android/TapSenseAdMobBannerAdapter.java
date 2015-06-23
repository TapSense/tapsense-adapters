package com.tapsense.adapters;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.os.Bundle;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.mediation.MediationAdRequest;
import com.google.android.gms.ads.mediation.customevent.CustomEventBanner;
import com.google.android.gms.ads.mediation.customevent.CustomEventBannerListener;
import com.tapsense.android.publisher.TSErrorCode;
import com.tapsense.android.publisher.TapSenseAdView;
import com.tapsense.android.publisher.TapSenseAdViewListener;
import com.tapsense.android.publisher.TapSenseAds;

public class TapSenseAdMobBannerAdapter implements CustomEventBanner,
    TapSenseAdViewListener {

  private CustomEventBannerListener mBannerListener;
  private TapSenseAdView mBannerView;

  /**
   * {@link CustomEventBanner} methods
   */

  @Override
  public void requestBannerAd(Context context,
      CustomEventBannerListener listener, String serverParameter, AdSize size,
      MediationAdRequest mediationAdRequest, Bundle customEventExtras) {
    try {
      // Remove test mode before going live and submitting to Play Store
      TapSenseAds.setTestMode();

      mBannerListener = listener;

      JSONObject serverParameterJson = new JSONObject(serverParameter);

      mBannerView = new TapSenseAdView(context);
      mBannerView.setAdUnitId(serverParameterJson.getString("adUnitId"));
      mBannerView.setAdViewListener(this);

      // Load the ad in the background
      mBannerView.loadAd();
    } catch (JSONException e) {
      listener.onAdFailedToLoad(AdRequest.ERROR_CODE_INVALID_REQUEST);
    }
  }

  @Override
  public void onDestroy() {
    if (mBannerView != null) {
      mBannerView.destroy();
    }
  }

  @Override
  public void onPause() {

  }

  @Override
  public void onResume() {

  }

  /**
   * {@link TapSenseAdViewListener} methods.
   * 
   * Note: {@link TapSenseAdViewListener} does not have an equivalent of
   * {@link CustomEventBannerListener#onAdClicked} or
   * {@link CustomEventBannerListener#onAdLeftApplication}
   */

  @Override
  public void onAdViewLoaded(TapSenseAdView adView) {
    if (mBannerListener != null) {
      mBannerListener.onAdLoaded(adView);
    }
  }

  @Override
  public void onAdViewFailedToLoad(TapSenseAdView adView, TSErrorCode errorCode) {
    if (mBannerListener != null) {
      switch (errorCode) {
      case INVALID_AD_SIZE:
      case INVALID_AD_UNIT_ID:
        mBannerListener.onAdFailedToLoad(AdRequest.ERROR_CODE_INVALID_REQUEST);
        break;
      case NO_FILL:
        mBannerListener.onAdFailedToLoad(AdRequest.ERROR_CODE_NO_FILL);
        break;
      case NO_INTERNET:
        mBannerListener.onAdFailedToLoad(AdRequest.ERROR_CODE_NETWORK_ERROR);
        break;
      default:
        mBannerListener.onAdFailedToLoad(AdRequest.ERROR_CODE_INTERNAL_ERROR);
        break;
      }
    }
  }

  @Override
  public void onAdViewExpanded(TapSenseAdView adView) {
    if (mBannerListener != null) {
      mBannerListener.onAdOpened();
    }
  }

  @Override
  public void onAdViewCollapsed(TapSenseAdView adView) {
    if (mBannerListener != null) {
      mBannerListener.onAdClosed();
    }
  }

}
