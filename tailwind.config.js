/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        pastel: {
          mint: '#D8F3DC',
          mintDark: '#95D5B2',
          sage: '#B7E4C7',
          deepSage: '#52B788',
          forest: '#2D6A4F',
          lavender: '#EAE4F8',
          lavenderLight: '#F3F0FB',
          lavenderDark: '#C7B9F1',
          lavenderDeep: '#7B5EA7',
          lavenderText: '#4A3B69',
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
      },
      boxShadow: {
        'soft': '0 4px 20px -2px rgba(123, 94, 167, 0.08), 0 2px 6px -1px rgba(82, 183, 136, 0.08)',
        'soft-lg': '0 10px 30px -4px rgba(123, 94, 167, 0.12), 0 4px 12px -2px rgba(82, 183, 136, 0.12)',
      }
    },
  },
  plugins: [],
}
