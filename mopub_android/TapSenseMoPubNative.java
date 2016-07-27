package com.mopub.nativeads;

import static com.mopub.nativeads.NativeImageHelper.preCacheImages;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.view.View;

import com.tapsense.android.publisher.TSErrorCode;
import com.tapsense.android.publisher.TapSenseAds;
import com.tapsense.android.publisher.TapSenseNativeAd;
import com.tapsense.android.publisher.TapSenseNativeAd.TapSenseNativeAdListener;

/*
 * Tested with TapSense SDK version 2.5.0
 */
public class TapSenseMoPubNative extends CustomEventNative {
  private static final String AD_UNIT_ID_KEY = "ad_unit_id";

  @Override
  protected void loadNativeAd(final Activity context,
      final CustomEventNativeListener customEventNativeListener,
      final Map<String, Object> localExtras,
      final Map<String, String> serverExtras) {

    String adUnitId = serverExtras.containsKey(AD_UNIT_ID_KEY) ? serverExtras
        .get(AD_UNIT_ID_KEY) : "";
        
    if (adUnitId == null || adUnitId.length() == 0) {
      customEventNativeListener
          .onNativeAdFailed(NativeErrorCode.NATIVE_ADAPTER_CONFIGURATION_ERROR);
      return;
    }

    // Remove test mode before going live and submitting to Play Store
    TapSenseAds.setTestMode();

    final TapSenseStaticNativeAd tapSenseStaticNativeAd = new TapSenseStaticNativeAd(
        context, new ImpressionTracker(context),
        new NativeClickHandler(context), customEventNativeListener,
        new TapSenseNativeAd(context, adUnitId));
    tapSenseStaticNativeAd.loadAd();
  }

  static class TapSenseStaticNativeAd extends StaticNativeAd implements
      TapSenseNativeAdListener {

    private final Context mContext;
    private final ImpressionTracker mImpressionTracker;
    private final NativeClickHandler mNativeClickHandler;
    private final CustomEventNativeListener mCustomEventNativeListener;
    private final TapSenseNativeAd mNativeAd;

    TapSenseStaticNativeAd(final Context context,
        final ImpressionTracker impressionTracker,
        final NativeClickHandler nativeClickHandler,
        final CustomEventNativeListener customEventNativeListener,
        final TapSenseNativeAd nativeAd) {
      mContext = context.getApplicationContext();
      mCustomEventNativeListener = customEventNativeListener;
      mImpressionTracker = impressionTracker;
      mNativeClickHandler = nativeClickHandler;
      mNativeAd = nativeAd;
    }

    void loadAd() {
      mNativeAd.setListener(this);
      mNativeAd.loadAd();
    }
    
    @Override
    public void prepare(final View view) {
      mImpressionTracker.addView(view, this);
      mNativeClickHandler.setOnClickListener(view, this);
    }

    @Override
    public void clear(final View view) {
      mImpressionTracker.removeView(view);
      mNativeClickHandler.clearOnClickListener(view);
    }

    @Override
    public void recordImpression(final View view) {
      super.recordImpression(view);
      try {
        mNativeAd.sendImpression();
      } catch (Exception e) {
      }
    }
    
    @Override
    public void handleClick(final View view) {
        notifyAdClicked();
        mNativeClickHandler.openClickDestinationUrl(getClickDestinationUrl(), view);
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

      preCacheImages(mContext, imageUrls,
          new NativeImageHelper.ImageListener() {
            @Override
            public void onImagesCached() {
              mCustomEventNativeListener
                  .onNativeAdLoaded(TapSenseStaticNativeAd.this);
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
