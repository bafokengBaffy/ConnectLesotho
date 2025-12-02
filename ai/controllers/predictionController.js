const predictionService = require('../services/predictionService');

const predictionController = {
  predictBusinessSuccess: async (req, res) => {
    try {
      const { businessData } = req.body;
      const prediction = await predictionService.analyzeBusinessSuccess(businessData);
      
      res.json({
        success: true,
        prediction: prediction.probability,
        factors: prediction.factors,
        recommendations: prediction.recommendations
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error predicting business success',
        error: error.message
      });
    }
  },

  predictFundingSuccess: async (req, res) => {
    try {
      const { fundingData } = req.body;
      const prediction = await predictionService.analyzeFundingSuccess(fundingData);
      
      res.json({
        success: true,
        prediction: prediction.probability,
        factors: prediction.factors,
        suggestions: prediction.suggestions
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error predicting funding success',
        error: error.message
      });
    }
  }
};

module.exports = predictionController;
