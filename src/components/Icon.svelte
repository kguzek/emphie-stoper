<script lang="ts">
	// Workarounds since I cannot find the actual type declarations
	interface HTMLProps<_1, _2> {}
	interface SVGAttributes<_> {}

	export let dimensions = 36;

	// This explicit type declaration is necessary because otherwise there is a type mismatch when inserting `svg.attributes`.
	interface SVGDefinition {
		[name: string]: { attributes: HTMLProps<'svg', SVGAttributes<any>>; svg: string };
	}

	const svgs: SVGDefinition = {
		timer: {
			attributes: {},
			svg: `<path fill="none" d="M0 0h24v24H0z" /><path d="M17.618 5.968l1.453-1.453 1.414 1.414-1.453 1.453a9 9 0 1 1-1.414-1.414zM12 20a7 7 0 1 0 0-14 7 7 0 0 0 0 14zM11 8h2v6h-2V8zM8 1h8v2H8V1z" fill="#808080" />`
		},
		cross: {
			attributes: {
				stroke: '#f55',
				'stroke-width': '2',
				'stroke-linecap': 'round',
				'stroke-linejoin': 'round'
			},
			svg: `<line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" />`
		}
	};
	export let name: string & keyof typeof svgs;
	$: svg = svgs[name];
</script>

<svg
	class={name}
	xmlns="http://www.w3.org/2000/svg"
	viewBox="0 0 24 24"
	width={dimensions}
	height={dimensions}
	{...svg.attributes}
>
	{@html svg.svg}
</svg>
