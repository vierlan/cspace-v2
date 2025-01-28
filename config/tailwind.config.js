const defaultTheme = require('tailwindcss/defaultTheme');
const colors = require('tailwindcss/colors');

module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*',
    './public/*.html',
  ],
  theme: {
    fontFamily: {
      heading: ['Clash Display', ...defaultTheme.fontFamily.sans],
      sans: ['Helvetica', 'Arial', 'sans-serif'],
    },
    extend: {
      colors: {
        amber: {
          800: '#967878',
        },
        primary: '#1E293B', // Slate 800
        secondary: '#64748B', // Slate 500
        accent: '#3B82F6', // Blue 500
        danger: '#EF4444', // Red 500
        success: '#22C55E', // Green 500
        warning: '#F59E0B', // Amber 500
        info: '#3B82F6', // Blue 500
      },
      backgroundImage: {
        'group': "url('app/assets/images/group.png')",
        'hero-pattern': "url('app/assets/images/hero-pattern.png')",
      },
      backgroundColor: {
        'brand-teal': '#BECDC1',
      },
      keyframes: {
        flashfade: {
          '0%, 100%': { opacity: '0' },
          '5%, 80%': { opacity: '1' },
        },
        slidein: {
          '0%': { transform: 'translateY(-100%)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        slideout: {
          '0%': { transform: 'translateY(0)', opacity: '1' },
          '100%': { transform: 'translateY(-100%)', opacity: '0' },
        },
      },
      animation: {
        flashfade: 'flashfade 1s ease-in-out',
        slidein: 'slidein 0.5s ease-out',
        slideout: 'slideout 0.5s ease-in',
      },
      spacing: {
        '1/2': '50%',
        '1/3': '33.333333%',
        '2/3': '66.666667%',
        '1/4': '25%',
        '3/4': '75%',
        '4/5': '80%',
        '5/6': '83.333333%',
        '11/12': '91.666667%',
        '12': '3rem',
        '20': '5rem',
        '72': '18rem',
      },
      borderRadius: {
        xl: '1.5rem',
        '2xl': '2rem',
      },
      boxShadow: {
        soft: '0 2px 10px rgba(0, 0, 0, 0.1)',
        strong: '0 4px 20px rgba(0, 0, 0, 0.2)',
      },
    },
  },
  variants: {
    extend: {
      padding: ['responsive'],
      backgroundColor: ['active'],
      textColor: ['active'],
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ],
};
