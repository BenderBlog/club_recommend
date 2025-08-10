<script lang="ts">
	import type { PageProps } from './$types';
	import ClubDetailView from '$lib/components/ClubDetail.svelte';
	import ReloadWidget from '$lib/components/ReloadWidget.svelte';
	import { browser } from '$app/environment';
	import Footer from '$lib/components/Footer.svelte';

	let { data }: PageProps = $props();

	let clubInfoResult = $state(data.clubInfoResult);

	function reloadPage() {
		if (browser) {
			window.location.reload();
		}
	}
</script>

<div class="flex min-h-screen flex-col">
	<div class="flex-grow">
		{#if clubInfoResult}
			{#if clubInfoResult.isOk()}
				<ClubDetailView info={clubInfoResult.value} />
			{:else}
				<div class="p-8">
					<ReloadWidget
						message={`遇到错误: ${clubInfoResult.error.message}`}
						onReload={reloadPage}
					/>
				</div>
			{/if}
		{:else}
			<div class="p-8">
				<ReloadWidget message={'该 code 对应的社团信息不存在'} onReload={reloadPage} />
			</div>
		{/if}
	</div>
	<Footer></Footer>
</div>
