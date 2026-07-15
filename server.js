const express = require('express');
const app = express();

app.use(express.json({ limit: '320kb' }));

const sessions = Object.create(null);

setInterval(() => {
    try {
        const now = Math.floor(Date.now() / 1000);
        const MAX_INACTIVITY = 900; // 15 minutes
        const roomIds = Object.keys(sessions);

        for (const id of roomIds) {
            if (sessions[id] && sessions[id].lastAccessed) {
                const idleTime = now - sessions[id].lastAccessed;
                if (idleTime > MAX_INACTIVITY) {
                    console.log(`[CLEANUP] Room ${id} removed.`);
                    delete sessions[id];
                }
            }
        }
    } catch (err) {
        console.error("Cleanup interval error:", err.message);
    }
}, 30000);

app.get('/', (req, res) => {
    res.status(200).send('My PLĀAĀAAATEEESSSS (Online.)');
});

app.post('/update', (req, res) => {
    try {
        const sessionId = req.headers['x-session-id'];
        if (!sessionId) {
            return res.status(400).json({ error: "Missing x-session-id header" });
        }

        const isExistingRoom = sessions[sessionId] !== undefined;

        sessions[sessionId] = {
            data: req.body || {},
            lastAccessed: Math.floor(Date.now() / 1000)
        };

        const responseMsg = isExistingRoom ? "Room Joined!" : "New Room Created!";
        return res.status(200).json({ success: true, message: responseMsg });

    } catch (error) {
        console.error("Error in /update handler:", error.message);
        return res.status(500).json({ error: "Internal server error code 1" });
    }
});

app.get('/get-sync', (req, res) => {
    try {
        const sessionId = req.headers['x-session-id'];
        if (!sessionId) {
            return res.status(400).json({ error: "Missing x-session-id header" });
        }

        const session = sessions[sessionId];
        if (!session) {
            return res.status(200).json({ initialized: false, message: "Waiting for host..." });
        }
        
        session.lastAccessed = Math.floor(Date.now() / 1000);
        return res.status(200).json(session.data || {});

    } catch (error) {
        console.error("Error in /get-sync handler:", error.message);
        return res.status(500).json({ error: "Internal server error code 2" });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`[SERVER RUNNING] Active on port ${PORT}`));
