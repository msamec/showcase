import { NextResponse } from 'next/server';
import { Octokit } from '@octokit/rest';
import { COMMIT_MESSAGES } from '../../constants';

export async function POST(req: Request) {
  const { commitMessage } = await req.json();

  const commitMessageEntry = COMMIT_MESSAGES.find(
    (message) => message.value === commitMessage
  );

  if (!commitMessageEntry) {
    return NextResponse.json(
      { message: 'Invalid commit message value provided.' },
      { status: 400 }
    );
  }

  let commitMessageWithFooter = commitMessageEntry.label;

  if (commitMessageEntry.label.includes('!')) {
    const footer = `BREAKING CHANGE: ${commitMessageEntry.label}`;
    commitMessageWithFooter += `\n\n${footer}`;
  }

  const octokit = new Octokit({
    auth: process.env.GITHUB_TOKEN,
  });

  try {
    const { data: refData } = await octokit.git.getRef({
      owner: process.env.GITHUB_USERNAME || '',
      repo: process.env.GITHUB_REPO || '',
      ref: 'heads/master',
    });

    const commitSha = refData.object.sha;

    const { data: commitData } = await octokit.git.getCommit({
      owner: process.env.GITHUB_USERNAME || '',
      repo: process.env.GITHUB_REPO || '',
      commit_sha: commitSha,
    });

    const lastCommitDate = new Date(commitData.committer.date);
    const currentTime = new Date();
    const timeDifference = (currentTime.getTime() - lastCommitDate.getTime()) / 1000;

    if (timeDifference < 120) {
      return NextResponse.json(
        { message: 'Error: You cannot commit more then once every 2 minutes.' },
        { status: 400 }
      );
    }

    const treeSha = commitData.tree.sha;

    const { data: newCommitData } = await octokit.git.createCommit({
      owner: process.env.GITHUB_USERNAME || '',
      repo: process.env.GITHUB_REPO || '',
      message: commitMessageWithFooter,
      tree: treeSha,
      parents: [commitSha],
    });

    await octokit.git.updateRef({
      owner: process.env.GITHUB_USERNAME || '',
      repo: process.env.GITHUB_REPO || '',
      ref: 'heads/master',
      sha: newCommitData.sha,
    });

    return NextResponse.json({ message: `Commit created!` });
  } catch (error) {
    return NextResponse.json({ message: 'An error occurred while checking workflows.' }, { status: 500 });
  }
}
