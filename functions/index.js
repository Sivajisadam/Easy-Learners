const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const axios = require("axios");

// Get API Key from Firebase Config
const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const GEMINI_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${GEMINI_API_KEY}`;

// Cloud Function to handle Gemini API requests
exports.getGeminiResponse = onRequest(async (req, res) => {
    try {
        const { prompt } = req.body;

        if (!prompt) {
            res.status(400).json({ error: "Prompt is required" });
            return;
        }

        // Call Gemini API
        const response = await axios.post(GEMINI_URL, {
            contents: [{ parts: [{ text: prompt }] }],
        });

        res.json(response.data);
    } catch (error) {
        logger.error("Error calling Gemini API", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});
