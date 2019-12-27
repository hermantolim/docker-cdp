const puppeteer = require('puppeteer')
const devices = require('puppeteer/DeviceDescriptors');

async function main() {
    const browser = await puppeteer.launch({
        executablePath: "/usr/bin/chromium-browser"
    })

    const page = await browser.newPage()

    await page.emulate(devices['iPhone 6'])
    await page.goto('https://google.com/ncr')
    await page.screenshot({
        path: 'full.png',
        fullPage: true
    })

    console.log(await page.title())
    await browser.close()
}

main()