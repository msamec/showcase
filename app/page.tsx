'use client';

import { useState, useEffect } from 'react';
import { COMMIT_MESSAGES } from './constants';

export default function Home() {
  const [version, setVersion] = useState('');
  const [selectedCommitMessage, setSelectedCommitMessage] = useState(COMMIT_MESSAGES[0]?.value || '');
  const [message, setMessage] = useState('');
  const [isSuccess, setIsSuccess] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    fetch('/api/version')
      .then((res) => res.json())
      .then((data) => setVersion(data.version));
  }, []);

  const handleSubmit = async () => {
    setIsLoading(true);
    try {
      const commitRes = await fetch('/api/submit-commit', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ commitMessage: selectedCommitMessage }),
      });

      const commitData = await commitRes.json();
      setMessage(commitData.message);
      if (commitRes.ok) {
        setIsSuccess(true);
      } else {
        setIsSuccess(false);
      }
    } catch (error) {
      setMessage('An unexpected error occurred.');
      setIsSuccess(false)
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100 px-4">
      <div className="bg-white p-8 rounded-lg shadow-lg text-gray-800 max-w-7xl w-full">
        <h1 className="text-2xl font-bold mb-4 text-center">Showcase of Deployment Automation</h1>
        {/* Description Section */}
        <h1 className="text-3xl font-bold mb-4">Description</h1>
        <p className="mb-4 text-justify">
          The purpose of this application is to use popular and often-used DevOps tools and principles, bringing them together in cohesion to demonstrate how you can easily automate testing, generate changelogs, deploy to a Kubernetes (K9s) infrastructure, and much more.
        </p>
        <h2 className="text-2xl font-bold mb-2">Disclaimer</h2>
        <p className="mb-4 text-justify text-sm text-gray-600">
          Some aspects of this application have been simplified for the purpose of better presentation. In a real production environment, certain implementations might differ to adhere to best practices and specific requirements.
        </p>

        <h1 className="text-3xl font-bold mb-4">Infrastructure</h1>
        <p className="mb-4 text-justify">
          This application leverages a variety of technologies and principles to create a cohesive DevOps environment. Below is a list of the key technologies and principles used:
        </p>
        <h2 className="text-2xl font-bold mb-2">Technologies</h2>
        <ul className="list-disc list-inside mb-4 ml-4">
          <li><strong>GitHub Actions</strong>: For continuous integration and automation of workflows.</li>
          <li><strong>GitHub Registry</strong>: For managing Docker images.</li>
          <li><strong>Docker</strong>: For containerizing applications.</li>
          <li><strong>Kubernetes</strong>: For orchestrating containerized applications, including components like:</li>
          <ul className="list-disc list-inside ml-8">
            <li><strong>NGINX Ingress</strong>: For managing external access to services in the cluster.</li>
            <li><strong>MetalLB</strong>: For providing network load balancing.</li>
            <li><strong>Cert-Manager</strong>: For managing SSL/TLS certificates.</li>
            <li><strong>Sealed Secrets</strong>: For securely managing secrets.</li>
          </ul>
          <li><strong>Helm</strong>: For managing Kubernetes applications.</li>
          <li><strong>Ansible</strong>: For automating configuration management and application deployment.</li>
          <li><strong>ArgoCD</strong>: For continuous deployment and managing GitOps workflows.</li>
          <ul className="list-disc list-inside ml-8">
            <li><strong>Keycloak</strong>: For identity and access management.</li>
          </ul>
          <li><strong>Prometheus</strong>: For monitoring and alerting.</li>
          <li><strong>Grafana</strong>: For visualizing monitoring data.</li>
        </ul>
        <h2 className="text-2xl font-bold mb-2">Principles</h2>
        <ul className="list-disc list-inside mb-4 ml-4">
          <li><strong>Conventional Commits</strong>: For maintaining a consistent commit history and automating versioning.</li>
        </ul>

        {/* Links Section */}
        <h1 className="text-3xl font-bold mb-4">Links</h1>
        <ul className="list-disc list-inside mb-4 ml-4">
          <li>
            <a href="https://github.com/msamec/showcase" className="text-blue-500 hover:underline" target="_blank" rel="noopener noreferrer">
              GitHub Repository
            </a>
          </li>
          <li>
            <a href="https://argocd.samec.dev" className="text-blue-500 hover:underline" target="_blank" rel="noopener noreferrer">
              ArgoCD UI (argocdpublic:RPTl4kMmhRwzjRq)
            </a>
          </li>
          <li>
            <a href="" className="text-blue-500 hover:underline" target="_blank" rel="noopener noreferrer">
              Grafana Dashboard (Coming Soon)
            </a>
          </li>
        </ul>
        <div className="border-t border-gray-300 mt-8 pt-4">
          <p className="mb-4 text-justify">
            You can see the current version of the app that is deployed. The value is taken from <code>package.json</code>, which is automatically bumped on commit following Conventional Commits. When a new commit is created, the pipeline will go through several stages:
          </p>
          <ul className="list-decimal list-inside mb-4 ml-4">
            <li>Testing and linting.</li>
            <li>Tagging the new version based on Conventional Commits.</li>
            <li>Building a new Docker image and pushing it to the registry.</li>
            <li>Updating the app version in the Helm values file.</li>
          </ul>
          <p className="mb-4 text-justify">
            You can try it yourself by selecting a commit message in the dropdown, which will create an empty commit with the selected message and trigger a workflow.
          </p>
          <p className="mb-4 text-center">
            <strong>Current Version:</strong> v{version}
          </p>
          <div className="flex flex-col items-center mb-4">
            <label htmlFor="commitMessage" className="mb-2 text-gray-700">
              Example Commit Message
            </label>
            <select
              id="commitMessage"
              value={selectedCommitMessage}
              onChange={(e) => setSelectedCommitMessage(e.target.value)}
              className="mb-2 p-2 border rounded"
            >
              {COMMIT_MESSAGES.map((message) => (
                <option key={message.value} value={message.value}>
                  {message.label}
                </option>
              ))}
            </select>
            <button
              onClick={handleSubmit}
              className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 flex items-center justify-center"
              disabled={isLoading}
            >
              {isLoading ? (
                <svg
                  className="animate-spin h-5 w-5 text-white"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <circle
                    className="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    strokeWidth="4"
                  ></circle>
                  <path
                    className="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8v4l3-3-3-3v4a8 8 0 11-8 8z"
                  ></path>
                </svg>
              ) : (
                'Commit and start workflow'
              )}
            </button>
            <div className={`mb-4 ${isSuccess ? 'text-green-500' : 'text-red-500'}`}>
              {message}
            </div>
            <p className="text-center text-sm text-gray-600">
              You can view the workflow details on the <a href="https://github.com/msamec/showcase/actions" className="text-blue-500 hover:underline" target="_blank" rel="noopener noreferrer">GitHub Actions page</a>.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
