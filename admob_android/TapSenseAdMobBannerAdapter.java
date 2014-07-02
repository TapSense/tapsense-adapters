package com.tapsense.adapters;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;

import com.google.ads.AdSize;
import com.google.ads.mediation.MediationAdRequest;
import com.google.ads.mediation.customevent.CustomEventBanner;
import com.google.ads.mediation.customevent.CustomEventBannerListener;
import com.tapsense.android.publisher.TSErrorCode;
import com.tapsense.android.publisher.TapSenseAdView;
import com.tapsense.android.publisher.TapSenseAdViewListener;
import com.tapsense.android.publisher.TapSenseAds;

public class TapSenseAdMobBannerAdapter implements CustomEventBanner,
    TapSenseAdViewListener {

  private CustomEventBannerListener mBannerListener;
  private TapSenseAdView mBannerView;

  @Override
  public void requestBannerAd(final CustomEventBannerListener listener,
      final Activity activity, String label, String serverParameter,
      AdSize adSize, MediationAdRequest request, Object customEventExtra) {

    try {
      // Remove test mode before going live and submitting to Play Store
      TapSenseAds.setTestMode();

      mBannerListener = listener;

      JSONObject serverParameterJson = new JSONObject(serverParameter);

      mBannerView = new TapSenseAdView(activity);
      mBannerView.setAdUnitId(serverParameterJson.getString("adUnitId"));
      mBannerView.setAdViewListener(this);

      // Load the ad in the background
      mBannerView.loadAd();
    } catch (JSONException e) {
      listener.onFailedToReceiveAd();
    }
  }

  @Override
  public void destroy() {
    if (mBannerView != null) {
      mBannerView.destroy();
    }
  }

  @Override
  public void onAdViewLoaded(TapSenseAdView adView) {
    if (mBannerListener != null) {
      mBannerListener.onReceivedAd(adView);
    }
  }

  @Override
  public void onAdViewFailedToLoad(TapSenseAdView adView, TSErrorCode errorCode) {
    if (mBannerListener != null) {
      mBannerListener.onFailedToReceiveAd();
    }
  }

  @Override
  public void onAdViewExpanded(TapSenseAdView adView) {
    if (mBannerListener != null) {
      mBannerListener.onPresentScreen();
    }
  }

  @Override
  public void onAdViewCollapsed(TapSenseAdView adView) {
    if (mBannerListener != null) {
      mBannerListener.onDismissScreen();
    }
  }

}
