using System;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace DefaultNamespace
{
    public class BackgroundDepthScaler : MonoBehaviour
    {
        [SerializeField] private FloatVariable _depthScale;
        [SerializeField] private float _desiredDepth;
        [SerializeField] private float _unitsPerScale;

        private void Start()
        {
            Scale();
        }

        [ContextMenu("Scale")]
        private void Scale()
        {
            var scaleY = _desiredDepth * _depthScale.Value / _unitsPerScale;
            var scale = transform.localScale;
            scale.y = scaleY;
            transform.localScale = scale;
        }
    }
}