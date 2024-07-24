Rails.application.config.session_store :redis_store,
  servers: [
    {
      host: "redis",
      port: 6379,
      db: 0,
      namespace: "session"
    }
  ],
  expire_after: 90.minutes,
  key: "_leaf_whisper_session",
  threadsafe: true,
  secure: Rails.env.production?