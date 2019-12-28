const puppeteer = require('puppeteer')
const devices = require('puppeteer/DeviceDescriptors');

async function main() {
    const dev = devices[Math.floor(Math.random() * devices.length)]
    let err = 0
    let browser
    try {
        browser = await puppeteer.launch()
        const page = await browser.newPage()

        await page.emulate(dev)
        await page.goto('https://httpbin.org/anything')

        const headers = await page
            .evaluate(() => document.body.innerText)
            .then(c => JSON.parse(c).headers)

        if (headers["User-Agent"] !== dev.userAgent) {
            throw new Error("device assertion failed")
        }

        console.log(JSON.stringify(headers))
    } catch (e) {
        console.log(e.message)
        err = 1
    } finally {
        browser && await browser.close()
    }

    process.exit(err)
}

main()