<script lang="ts">
	import { Layer } from 'm3-svelte';
	import { clubTypeName, type ClubInfo } from '$lib/model';

	export let data: ClubInfo;

	function goToCode() {
		window.location.href = '/detail/' + data.code;
	}
</script>

<button type="button" class="clubcard" onclick={goToCode}>
	<div class="flex flex-row items-center">
		<div class="mr-3 h-16 w-16 flex-shrink-0">
			<img src={data.icon} alt={data.title} class="h-full w-full rounded-full object-cover" />
		</div>
		<Layer />
		<div class="flex min-w-0 flex-1 flex-col justify-center">
			<div class="flex flex-row items-center justify-between gap-2">
				<h3 class="truncate text-base font-semibold">
					{data.title}
				</h3>

				<div class="flex flex-shrink-0 flex-row gap-1">
					{#each data.type as type}
						<span class="rounded-full bg-primary px-2 py-0.5 text-xs text-on-primary">
							{clubTypeName[type]}
						</span>
					{/each}
				</div>
			</div>

			<p class="mt-1 truncate text-sm text-on-surface-variant">
				{data.intro}
			</p>
		</div>
	</div>
</button>

<style>
	.clubcard {
		position: relative;
		padding: 1em;
		border: none;
		border-radius: var(--m3-util-rounding-medium);
		background-color: rgb(var(--m3-scheme-surface-container-highest));
		--m3-util-background: rgb(var(--m3-scheme-surface-container-highest));
		color: rgb(var(--m3-scheme-on-surface));
		overflow: hidden;
	}
	button {
		text-align: inherit;
		font: inherit;
		letter-spacing: inherit;
		cursor: pointer;
		-webkit-tap-highlight-color: transparent;
		border-radius: var(--m3-util-rounding-medium);
	}
	@media (hover: hover) {
		button:hover {
			box-shadow: var(--m3-util-elevation-1);
		}
	}
</style>
