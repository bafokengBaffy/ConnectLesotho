const express = require('express');
const router = express.Router();
const predictionController = require('../controllers/predictionController');
const recommendationController = require('../controllers/recommendationController');
const aiAnalyticsController = require('../controllers/aiAnalyticsController');

// Prediction routes
router.post('/predict/success', predictionController.predictBusinessSuccess);
router.post('/predict/funding', predictionController.predictFundingSuccess);

// Recommendation routes
router.post('/recommend/funding', recommendationController.recommendFunding);
router.post('/match/mentors', recommendationController.matchMentors);
router.get('/recommend/resources', recommendationController.recommendResources);

// Analytics routes
router.get('/insights/market', aiAnalyticsController.getMarketInsights);
router.post('/analyze/trends', aiAnalyticsController.analyzeTrends);
router.get('/analytics/performance', aiAnalyticsController.getPerformanceAnalytics);

module.exports = router;
