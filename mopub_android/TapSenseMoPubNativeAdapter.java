package com.mopub.nativeads;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import android.content.Context;

import com.tapsense.android.publisher.TSErrorCode;
import com.tapsense.android.publisher.TapSenseAds;
import com.tapsense.android.publisher.TapSenseNativeAd;
import com.tapsense.android.publisher.TapSenseNativeAd.TapSenseNativeAdListener;

/*
 * Tested with TapSense SDK version 2.5.0
 */
public class TapSenseMoPubNativeAdapter extends CustomEventNative {
  private static final String AD_UNIT_ID_KEY = "ad_unit_id";

  // CustomEventNative implementation
  @Override
  protected void loadNativeAd(final Context context,
      final CustomEventNativeListener customEventNativeListener,
      final Map<String, Object> localExtras,
      final Map<String, String> serverExtras) {

    String adUnitId = serverExtras.containsKey(AD_UNIT_ID_KEY) ? serverExtras
        .get(AD_UNIT_ID_KEY) : "";
      
    // Remove test mode before going live and submitting to Play Store
    TapSenseAds.setTestMode();

    final TapSenseForwardingNativeAd tapSenseForwardingNativeAd = new TapSenseForwardingNativeAd(
        context, new TapSenseNativeAd(context, adUnitId), customEventNativeListener);
    tapSenseForwardingNativeAd.loadAd();
  }

  static class TapSenseForwardingNativeAd extends BaseForwardingNativeAd
      implements TapSenseNativeAdListener {

    private final Context mContext;
    private final TapSenseNativeAd mNativeAd;
    private final CustomEventNativeListener mCustomEventNativeListener;

    TapSenseForwardingNativeAd(final Context context, TapSenseNativeAd nativeAd,
        final CustomEventNativeListener customEventNativeListener) {
      mContext = context.getApplicationContext();
      mNativeAd = nativeAd;
      mCustomEventNativeListener = customEventNativeListener;
    }

    @Override
    public void recordImpression() {
      super.recordImpression();
      try {
        mNativeAd.sendImpression();
      } catch (Exception e) {
      }
    }

    void loadAd() {
      mNativeAd.setListener(this);
      mNativeAd.loadAd();
    }

    @Override
    public void onNativeAdLoaded(TapSenseNativeAd nativeAd) {
      // set each element. may be null.
      setTitle(mNativeAd.getTitle());
      setText(mNativeAd.getText());
      setCallToAction(mNativeAd.getCtaText());
      setStarRating(mNativeAd.getStarRating());
      setMainImageUrl(mNativeAd.getImage());
      setIconImageUrl(mNativeAd.getIcon());
      setClickDestinationUrl(mNativeAd.getClickUrl());

      // download images
      final List<String> imageUrls = new ArrayList<String>();
      final String mainImageUrl = getMainImageUrl();
      if (mainImageUrl != null) {
        imageUrls.add(getMainImageUrl());
      }
      final String iconUrl = getIconImageUrl();
      if (iconUrl != null) {
        imageUrls.add(getIconImageUrl());
      }
      preCacheImages(mContext, imageUrls, new ImageListener() {
        @Override
        public void onImagesCached() {
          mCustomEventNativeListener
              .onNativeAdLoaded(TapSenseForwardingNativeAd.this);
        }

        @Override
        public void onImagesFailedToCache(NativeErrorCode errorCode) {
          mCustomEventNativeListener.onNativeAdFailed(errorCode);
        }
      });
    }

    @Override
    public void onNaitveAdFailedToLoad(TapSenseNativeAd nativeAd,
        TSErrorCode errorCode) {
      if (errorCode == TSErrorCode.CONNECTION_FAILURE) {
        mCustomEventNativeListener
            .onNativeAdFailed(NativeErrorCode.NETWORK_TIMEOUT);
      } else if (errorCode == TSErrorCode.NO_FILL
          || errorCode == TSErrorCode.NO_VALID_AD) {
        mCustomEventNativeListener
            .onNativeAdFailed(NativeErrorCode.NETWORK_NO_FILL);
      } else if (errorCode == TSErrorCode.INTERNAL_ERROR) {
        mCustomEventNativeListener
            .onNativeAdFailed(NativeErrorCode.NETWORK_INVALID_STATE);
      } else {
        mCustomEventNativeListener
            .onNativeAdFailed(NativeErrorCode.UNSPECIFIED);
      }
    }

    @Override
    public void destroy() {
      mNativeAd.destroy();
    }
  }
}
