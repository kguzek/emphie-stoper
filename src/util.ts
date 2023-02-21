/** Returns the result of integer division of two numbers as well as the integer remainder. */
const divmod = (dividend: number, divisor: number) => [
	Math.floor(dividend / divisor),
	dividend % divisor
];

/** Converts a numeric value into a string zero-padded to two digits. */
const zeroPadNumber = (number: number) => `${number}`.padStart(2, '0');

/** Converts a timespan in milliseconds into two strings representing the time up until hours.
 * 	E.g. (3600_000) => ["01:00:00", "000"]
 */
export function formatTime(milliseconds: number) {
	let hours, minutes, seconds;
	[seconds, milliseconds] = divmod(milliseconds, 1000);
	[minutes, seconds] = divmod(seconds, 60);
	[hours, minutes] = divmod(minutes, 60);
	const timeParts = [hours, minutes, seconds].map(zeroPadNumber);
	return [timeParts.join(':'), `${milliseconds}`.padStart(3, '0')];
}
