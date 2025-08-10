<script lang="ts">
	import { browser } from '$app/environment';
	import { Button, Icon, LinearProgressEstimate, Snackbar } from 'm3-svelte';
	import { getClubArticle, getClubImage } from '$lib/api';
	import iconLink from '@ktibow/iconset-material-symbols/link';
	import iconChat from '@ktibow/iconset-material-symbols/chat';
	import iconBack from '@ktibow/iconset-material-symbols/arrow-back';
	import { ClubInfo, clubTypeName } from '$lib/model';
	import AppBar from './AppBar.svelte';
	import ReloadWidget from './ReloadWidget.svelte';

	export let info: ClubInfo;

	let snackbar: ReturnType<typeof Snackbar>;

	$: articlePromise = info ? getClubArticle(info.code) : null;
	$: images = info ? Array.from({ length: info.pic }, (_, i) => getClubImage(info.code, i)) : [];

	async function copyQQ() {
		if (!info) return;
		await navigator.clipboard.writeText(info.qq);
		snackbar.show({ message: 'QQ 号已复制到剪贴板', closable: true });
	}

	function goToHome() {
		window.location.href = '/';
	}

	function openLink() {
		if (!info || !info.qqlink) {
			snackbar.show({ message: '未提供入群链接' });
			return;
		}
		window.open(info.qqlink, '_blank');
	}

	function reloadPage() {
		if (browser) window.location.reload();
	}
</script>

{#snippet iconbutton()}
	<div class="flex flex-shrink-0 items-center">
		<Button variant="text" onclick={copyQQ} iconType="full"><Icon icon={iconChat} /></Button>
		<Button variant="text" onclick={openLink} iconType="full"><Icon icon={iconLink} /></Button>
	</div>
{/snippet}

{#snippet leadingbutton()}
	<Button variant="text" onclick={goToHome} iconType="full"><Icon icon={iconBack} /></Button>
{/snippet}

{#snippet title()}
	<div>{info.title}</div>
{/snippet}

<AppBar {title} {iconbutton} {leadingbutton} bottom={null}></AppBar>
<div class="flex flex-col items-center px-4">
	<div class="my-12 flex flex-col items-center">
		<img src={info.icon} alt="Club Icon" class="mb-4 h-24 w-24 rounded-full object-cover" />
		<h2 class="m3-font-headline-small">{info.title}</h2>
		<p class="m3-font-body-large mt-1 text-on-surface-variant">{info.intro}</p>
	</div>
	{#if images.length > 0}
		<section class="mb-8">
			<div class="-mx-4 flex snap-x snap-mandatory gap-3 overflow-x-auto rounded-xl px-4">
				{#each images as imageUrl (imageUrl)}
					<img src={imageUrl} alt="社团照片" class="h-64 max-w-full rounded-lg" />
				{/each}
			</div>
		</section>
	{/if}
	{#if articlePromise}
		{#await articlePromise}
			<LinearProgressEstimate />
		{:then htmlContent}
			{#if htmlContent.isOk()}
				<article class="prose dark:prose-invert">
					{@html htmlContent.value}
				</article>
			{:else}
				<ReloadWidget message="社团介绍渲染失败: {htmlContent.error.message}" onReload={reloadPage}
				></ReloadWidget>
			{/if}
		{:catch error}
			<ReloadWidget message="社团介绍加载失败: {error.message}" onReload={reloadPage}
			></ReloadWidget>
		{/await}
	{/if}
</div>

<Snackbar bind:this={snackbar} />
