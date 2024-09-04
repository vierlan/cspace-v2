const defaultTheme = require('tailwindcss/defaultTheme')
const colors = require('tailwindcss/colors')


module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*'
  ],
  theme: {
    fontFamily: {
      sans: ['Helvatica', 'Arial', 'sans-serif'],
    },
    extend: {
      colors: {
        amber: {
          800: '#967878',
        }
      },
      backgroundImage: {
        'group': "url('app/assets/images/group.png')",
      },

      // custom color palette for branding, see https://tailwindcss.com/docs/customizing-colors
      backgroundColor: {
        'brand-teal': '#BECDC1',
      },
      keyframes: {
        flashfade: { "0%, 100%": { opacity: "0" }, "5%, 80%": { opacity: "1" } },
      },
      spacing: (
        {
          '1/2': '50%',
          '1/3': '33.333333%',
          '2/3': '66.666667%',
          '1/4': '25%',
          '3/4': '75%',
          '4/5': '80%',
          '5/6': '83.333333%',
          '11/12': '91.666667%',
        }
      ),

    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
