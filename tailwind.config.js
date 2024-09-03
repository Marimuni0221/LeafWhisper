/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/views/**/*.html.slim',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {},
  },
  plugins: [require('daisyui')],
  daisyui: {
    themes: [
      {
        mytheme: {
          "primary": "#A3D9A5",
          "secondary": "#bbf7d0",
          "accent": "#bbf7d0",
          "accordion": "#7fd9d2",
          "neutral": "#333333",
          "base-100": "#ffffff",
          "info": "#0000ff",
          "success": "#00ff00",
          "warning": "#ffcc00",
          "error": "#ff0000",
        },
      },
    ],
  },
}

